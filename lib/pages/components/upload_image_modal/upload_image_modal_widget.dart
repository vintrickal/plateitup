import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import '/cubits/app/app_cubit.dart';

/// Modal that lets the user either upload an image file or paste an image
/// URL, then writes it back to the right Firestore field based on
/// `requestId` (recipe banner, ingredient banner, profile photo, cover
/// photo). Holds the in-flight upload state locally.
///
/// Redesigned for clarity: a single tappable "Choose from device" tile at
/// the top, an "or" separator, then a URL input + Save button. Sizes to
/// content (`MainAxisSize.min`) so it no longer overflows on shorter
/// screens — the previous fixed 350px box used to clip on tall keyboards.
class UploadImageModalWidget extends StatefulWidget {
  const UploadImageModalWidget({
    super.key,
    this.docRef,
    required this.requestId,
    this.docRefUser,
  });

  final DocumentReference? docRef;
  final String? requestId;
  final DocumentReference? docRefUser;

  @override
  State<UploadImageModalWidget> createState() => _UploadImageModalWidgetState();
}

class _UploadImageModalWidgetState extends State<UploadImageModalWidget> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocus = FocusNode();

  bool _isDataUploading = false;
  // ignore: unused_field
  FFUploadedFile _uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String _uploadedFileUrl = '';

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  /// Writes the given URL to the right Firestore field based on `requestId`.
  /// Centralised so both the "pick from device" path and the "paste URL +
  /// Save" path go through the same code.
  Future<void> _persistUrl(String url) async {
    switch (widget.requestId) {
      case 'recipeBanner':
        await widget.docRef!.update(createMealRecipeRecordData(banner: url));
        AppCubit.instance.setIsBannerUploaded(true);
        break;
      case 'ingredientBanner':
        AppCubit.instance.setIngredientBanner(url);
        AppCubit.instance.setIsIngredientBannerUploaded(true);
        break;
      case 'profileBanner':
        await widget.docRefUser!
            .update(createUsersRecordData(photoUrl: url));
        break;
      case 'coverPhotoBanner':
        await widget.docRefUser!
            .update(createUsersRecordData(coverPhotoUrl: url));
        break;
    }
  }

  Future<void> _pickFromDevice() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
    );
    if (selectedMedia == null ||
        !selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      return;
    }

    setState(() => _isDataUploading = true);
    var selectedUploadedFiles = <FFUploadedFile>[];
    var downloadUrls = <String>[];
    try {
      showUploadMessage(context, 'Uploading…', showLoading: true);
      selectedUploadedFiles = selectedMedia
          .map((m) => FFUploadedFile(
                name: m.storagePath.split('/').last,
                bytes: m.bytes,
                height: m.dimensions?.height,
                width: m.dimensions?.width,
                blurHash: m.blurHash,
              ))
          .toList();

      downloadUrls = (await Future.wait(
        selectedMedia.map(
          (m) async => await uploadData(m.storagePath, m.bytes),
        ),
      ))
          .where((u) => u != null)
          .map((u) => u!)
          .toList();
    } finally {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _isDataUploading = false;
    }

    if (selectedUploadedFiles.length == selectedMedia.length &&
        downloadUrls.length == selectedMedia.length) {
      setState(() {
        _uploadedLocalFile = selectedUploadedFiles.first;
        _uploadedFileUrl = downloadUrls.first;
        _urlController.text = _uploadedFileUrl;
      });
      await _persistUrl(_uploadedFileUrl);
      showUploadMessage(context, 'Uploaded.');
      if (mounted) Navigator.pop(context);
    } else {
      setState(() {});
      showUploadMessage(context, 'Failed to upload data');
    }
  }

  Future<void> _saveUrl() async {
    if (!functions.httpChecker(_urlController.text)!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid URL link',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: const Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
      return;
    }
    await _persistUrl(_urlController.text);
    if (!mounted) return;
    Navigator.pop(context);
    _urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 480.0),
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 24.0,
                color: Colors.black.withOpacity(0.10),
                offset: const Offset(0.0, 8.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add image',
                            style: theme.headlineSmall.override(
                              fontFamily: 'Poppins',
                              color: theme.primaryText,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Pick a photo from your device or paste a URL.',
                            style: theme.bodyMedium.override(
                              fontFamily: 'Poppins',
                              color: theme.secondaryText,
                              fontSize: 13.0,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Material InkWell close button — keeps the tap target
                    // generous (40×40) without the heavy outlined look of
                    // FlutterFlowIconButton.
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {
                          _urlController.clear();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: theme.secondaryText,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),
                // Big "Choose from device" tile — primary action.
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.0),
                    onTap: _isDataUploading ? null : _pickFromDevice,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 18.0),
                      decoration: BoxDecoration(
                        color: theme.success.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: theme.success.withOpacity(0.35),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: theme.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 22.0,
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Choose from device',
                                  style: theme.bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: theme.primaryText,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  'JPG or PNG, up to 5 MB',
                                  style: theme.bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    color: theme.secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: theme.secondaryText,
                            size: 14.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                // "or" divider.
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: theme.alternate,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'or',
                        style: theme.bodyMedium.override(
                          fontFamily: 'Poppins',
                          color: theme.secondaryText,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: theme.alternate,
                        thickness: 1.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // URL field.
                Text(
                  'Image URL',
                  style: theme.bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: theme.primaryText,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: _urlController,
                  focusNode: _urlFocus,
                  autofocus: false,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'https://example.com/photo.jpg',
                    hintStyle: theme.labelMedium.override(
                      fontFamily: 'Poppins',
                      color: theme.secondaryText,
                      fontSize: 13.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.link_rounded,
                      color: theme.secondaryText,
                      size: 20.0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.alternate,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.success,
                        width: 1.8,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.error,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.error,
                        width: 1.8,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 14.0),
                  ),
                  style: theme.bodyMedium.override(
                    fontFamily: 'Poppins',
                    color: theme.primaryText,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18.0),
                // Save button.
                FFButtonWidget(
                  onPressed: _saveUrl,
                  text: 'Save',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 46.0,
                    padding: EdgeInsets.zero,
                    iconPadding: EdgeInsets.zero,
                    color: theme.success,
                    textStyle: theme.titleSmall.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
