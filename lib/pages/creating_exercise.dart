import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rehabilitacion_app/services/exercise_firebase_service.dart';
import 'package:rehabilitacion_app/services/exercise_form_provider.dart';
import 'package:rehabilitacion_app/ui/input_decorations.dart';
import 'package:rehabilitacion_app/widgets/card_image.dart';

class CreatingExercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exerciseService = Provider.of<ExerciseFirebaseService>(context);

    return ChangeNotifierProvider(
      create: (_) => ExerciseFormProvider(exerciseService.selectedExercise!),
      child: _CreatingExercisePageBody(exerciseService: exerciseService),
    );
  }
}

class _CreatingExercisePageBody extends StatelessWidget {
  final ExerciseFirebaseService exerciseService;

  const _CreatingExercisePageBody({
    Key? key,
    required this.exerciseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exerciseForm = Provider.of<ExerciseFormProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  GeneralImage(
                    url: exerciseService.selectedExercise!.video,
                  ),
                  Positioned(
                    top: 30.0,
                    left: 30.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    right: 30.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = await picker.getImage(
                          source: ImageSource.camera,
                          imageQuality: 100,
                        );
                        if (pickedFile == null) {
                          print('No hay selección');
                          return;
                        }
                        exerciseService
                            .updateSelectedExerciseImage(pickedFile.path);
                      },
                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    right: 30.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = await picker.getVideo(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile == null) {
                          return;
                        }
                        exerciseService
                            .updateSelectedExerciseImage(pickedFile.path);
                      },
                      // onPressed: () async {
                      //   final picker = new ImagePicker();
                      //   final PickedFile? pickedFile = await picker.getImage(
                      //     source: ImageSource.gallery,
                      //     imageQuality: 100,
                      //   );
                      //   if (pickedFile == null) {
                      //     print('No hay selección');
                      //     return;
                      //   }
                      //   exerciseService
                      //       .updateSelectedExerciseImage(pickedFile.path);
                      // },
                    ),
                  ),
                ],
              ),
              _Form(),
              // SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: exerciseService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.save_outlined),
        onPressed: exerciseService.isSaving
            ? null
            : () async {
                if (!exerciseForm.isValidForm()) return;

                final String? imageUrl = await exerciseService.uploadImage();

                if (imageUrl != null) exerciseForm.exercise.video = imageUrl;

                await exerciseService
                    .saveOrCreateExercise(exerciseForm.exercise);
                FocusScope.of(context).unfocus();
                // Navigator.pop(context);
              },
      ),
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exerciseForm = Provider.of<ExerciseFormProvider>(context);
    final exercise = exerciseForm.exercise;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: exerciseForm.formKey,
          // autoValidateMode: AutovalidateMode.onUserInteraction permite
          // que el mensaje de error en la validación del campo del formulario
          // se quite en cuanto el usuario comienza a interactuar
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: exercise.nombre,
                onChanged: (value) => exercise.nombre = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del ejercicio',
                  labelText: 'Nombre:',
                ),
              ),
              // SizedBox(height: 10.0),

              SizedBox(height: 30.0),
              // SwitchListTile.adaptive(
              //   title: Text('Disponible'),
              //   activeColor: Colors.indigo,
              //   value: therapy.available,
              //   onChanged: therapyForm.updateAvailability,
              //   // onChanged: (value) => productForm.updateAvailability(value),
              // ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(25.0),
        bottomLeft: Radius.circular(25.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 5),
          blurRadius: 5,
        ),
      ],
    );
  }
}
