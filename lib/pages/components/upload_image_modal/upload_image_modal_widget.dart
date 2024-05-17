import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'upload_image_modal_model.dart';
export 'upload_image_modal_model.dart';

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
  late UploadImageModalModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadImageModalModel());

    _model.modalUrlTextFieldTextController ??= TextEditingController();
    _model.modalUrlTextFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
        child: Container(
          width: double.infinity,
          height: 350.0,
          constraints: BoxConstraints(
            maxWidth: 570.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Color(0xFFE0E3E7),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                        child: Text(
                          'Image Upload',
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Roboto',
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor:
                          FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: 30.0,
                      borderWidth: 2.0,
                      buttonSize: 44.0,
                      icon: Icon(
                        Icons.close_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          _model.modalUrlTextFieldTextController?.clear();
                        });
                      },
                    ),
                  ],
                ),
                Divider(
                  height: 24.0,
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                TextFormField(
                  controller: _model.modalUrlTextFieldTextController,
                  focusNode: _model.modalUrlTextFieldFocusNode,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                    hintText: 'Insert Link',
                    hintStyle:
                        FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Poppins',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                      ),
                  validator: _model.modalUrlTextFieldTextControllerValidator
                      .asValidator(context),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          final selectedMedia =
                              await selectMediaWithSourceBottomSheet(
                            context: context,
                            allowPhoto: true,
                          );
                          if (selectedMedia != null &&
                              selectedMedia.every((m) =>
                                  validateFileFormat(m.storagePath, context))) {
                            setState(() => _model.isDataUploading = true);
                            var selectedUploadedFiles = <FFUploadedFile>[];

                            var downloadUrls = <String>[];
                            try {
                              showUploadMessage(
                                context,
                                'Uploading file...',
                                showLoading: true,
                              );
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
                                  (m) async =>
                                      await uploadData(m.storagePath, m.bytes),
                                ),
                              ))
                                  .where((u) => u != null)
                                  .map((u) => u!)
                                  .toList();
                            } finally {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              _model.isDataUploading = false;
                            }
                            if (selectedUploadedFiles.length ==
                                    selectedMedia.length &&
                                downloadUrls.length == selectedMedia.length) {
                              setState(() {
                                _model.uploadedLocalFile =
                                    selectedUploadedFiles.first;
                                _model.uploadedFileUrl = downloadUrls.first;
                              });
                              showUploadMessage(context, 'Success!');
                            } else {
                              setState(() {});
                              showUploadMessage(
                                  context, 'Failed to upload data');
                              return;
                            }
                          }

                          if (_model.uploadedFileUrl != '') {
                            if (widget.requestId == 'recipeBanner') {
                              await widget.docRef!
                                  .update(createMealRecipeRecordData(
                                banner: _model.uploadedFileUrl,
                              ));
                            } else {
                              if (widget.requestId == 'ingredientBanner') {
                                setState(() {
                                  FFAppState().ingredientBanner =
                                      _model.uploadedFileUrl;
                                });
                              } else {
                                if (widget.requestId == 'profileBanner') {
                                  await widget.docRefUser!
                                      .update(createUsersRecordData(
                                    photoUrl: _model.uploadedFileUrl,
                                  ));
                                }
                              }
                            }

                            setState(() {
                              _model.modalUrlTextFieldTextController?.text =
                                  _model.uploadedFileUrl;
                            });
                          }
                        },
                        text: 'Upload',
                        options: FFButtonOptions(
                          width: 130.0,
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          hoverColor: Color(0xFF2B16ED),
                          hoverTextColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 1.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (functions.httpChecker(
                          _model.modalUrlTextFieldTextController.text)!) {
                        if (widget.requestId == 'recipeBanner') {
                          await widget.docRef!
                              .update(createMealRecipeRecordData(
                            banner: _model.modalUrlTextFieldTextController.text,
                          ));
                          Navigator.pop(context);
                          setState(() {
                            _model.modalUrlTextFieldTextController?.clear();
                          });
                          setState(() {
                            FFAppState().isBannerUploaded = true;
                          });
                        } else {
                          if (widget.requestId == 'ingredientBanner') {
                            _model.updatePage(() {
                              FFAppState().ingredientBanner =
                                  _model.modalUrlTextFieldTextController.text;
                            });
                            Navigator.pop(context);
                            setState(() {
                              _model.modalUrlTextFieldTextController?.clear();
                            });
                            setState(() {
                              FFAppState().isIngredientBannerUploaded = true;
                            });
                          } else {
                            if (widget.requestId == 'profileBanner') {
                              await widget.docRefUser!
                                  .update(createUsersRecordData(
                                photoUrl:
                                    _model.modalUrlTextFieldTextController.text,
                              ));
                              Navigator.pop(context);
                              setState(() {
                                _model.modalUrlTextFieldTextController?.clear();
                              });
                            } else {
                              if (widget.requestId == 'coverPhotoBanner') {
                                await widget.docRefUser!
                                    .update(createUsersRecordData(
                                  coverPhotoUrl: _model
                                      .modalUrlTextFieldTextController.text,
                                ));
                                Navigator.pop(context);
                                setState(() {
                                  _model.modalUrlTextFieldTextController
                                      ?.clear();
                                });
                              }
                            }
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Invalid URL link',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    text: 'Save',
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).success,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      elevation: 3.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
