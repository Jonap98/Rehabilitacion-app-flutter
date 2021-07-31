import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rehabilitacion_app/models/exercise.dart';
import 'package:rehabilitacion_app/services/exercise_firebase_service.dart';
import 'package:rehabilitacion_app/widgets/exercise_card.dart';

class ExercisesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exerciseService = Provider.of<ExerciseFirebaseService>(context);
    final therapyId = ModalRoute.of(context)!.settings.arguments;

    final List<Exercise> exercisesTemp = [];

    for (var i = 0; i < exerciseService.exercises.length; i++) {
      if (exerciseService.exercises[i].idTerapia == therapyId)
        exercisesTemp.add(exerciseService.exercises[i]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios'),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: exercisesTemp.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {},
          onDoubleTap: () {
            exerciseService.selectedExercise = exercisesTemp[index].copy();

            Navigator.pushNamed(
              context,
              'creating_exercise',
            );
          },
          child: ExerciseCard(
            exercise: exercisesTemp[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          exerciseService.selectedExercise = new Exercise(
            idTerapia: therapyId.toString(),
            nombre: '',
          );
          Navigator.pushNamed(context, 'creating_exercise');
        },
      ),
    );
  }
}
