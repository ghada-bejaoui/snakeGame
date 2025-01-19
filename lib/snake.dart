import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'Grille.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => Game();
}

class Game extends State<Snake> {
  List<Offset> snake = [
    Offset(3, 3),
    Offset(4, 3),
    Offset(5, 3),
  ];
  int score = 0;

  Offset direction = Offset(1, 0); // Direction actuelle
  Timer? timer;
  Offset apple =
      Offset(Random().nextInt(20).toDouble(), Random().nextInt(20).toDouble());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake game',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Text('Speed: ${300 - (score ~/ 5) * 30} ms')
          // Affichage de la vitesse du jeu
          ,
          Text(
            'Score: $score', // Afficher le score en haut de l'écran
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: CustomPaint(
              painter: Grille(snake: snake, apple: apple),
              child: Container(),
            ),
          ),
          directionButtons(),
        ],
      ),
    );
  }

  Offset _wrapAround(Offset newHead) {
    final newHeadX = newHead.dx % 20;  // La largeur de la grille est 20
    final newHeadY = newHead.dy % 20;  // La hauteur de la grille est 20

    // Si les coordonnées sont négatives, on les ajuste pour les faire apparaître à l'autre côté
    return Offset(
      newHeadX < 0 ? 20 + newHeadX : newHeadX,
      newHeadY < 0 ? 20 + newHeadY : newHeadY,
    );
  }

  void moveSnake() {
    setState(() {
      final newHead = snake.last + direction;
      final wrappedHead = _wrapAround(newHead);

      // Vérifier si la tête entre en collision avec le corps du serpent
      if (snake.contains(wrappedHead)) {
        // Si collision, arrêter le jeu et afficher l'option Rejouer
        timer?.cancel(); // Arrêter le timer
        _showGameOverDialog(); // Afficher le dialogue de fin de jeu
        return; // Ne pas faire avancer le serpent
      }

      snake.add(wrappedHead);

      // Si le serpent mange la pomme
      if (wrappedHead == apple) {
        apple = _generateApple(snake);
        score++;
      } else {
        snake.removeAt(0); // Supprimer la queue du serpent
      }

      // Mettre à jour la vitesse du jeu si nécessaire
      _updateGameSpeed();
    });
  }


  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche de fermer la boîte de dialogue en dehors
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sports_esports,
                  size: 80,
                  color: Colors.orange,
                ),
                SizedBox(height: 10),
                Text(
                  "Game Over",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(height: 10),
                Text(
                  "Your score: $score",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                    _restartGame(); // Redémarrer le jeu
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur du bouton
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Rejouer"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      snake = [
        Offset(3, 3),
        Offset(4, 3),
        Offset(5, 3),
      ];
      direction = Offset(1, 0); // Reset de la direction
      score = 0; // Réinitialiser le score
      apple = _generateApple(snake); // Générer une nouvelle pomme
      timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        moveSnake();
      });
    });
  }

  void _updateGameSpeed() {
    if (score % 5 == 0) {
      // Par exemple, toutes les 5 pommes mangées
      timer?.cancel();
      timer = Timer.periodic(
          Duration(milliseconds: max(100, 300 - (score ~/ 5) * 30)), (timer) {
        moveSnake();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      // Vitesse augmentée
      moveSnake();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void changeDirection(Offset newDirection) {
    if ((direction.dx + newDirection.dx).abs() != 0 ||
        (direction.dy + newDirection.dy).abs() != 0) {
      direction = newDirection;
    }
  }

  // Génère une position aléatoire pour la pomme si elle est sur snake
  static Offset _generateApple(List<Offset> snake) {
    Offset apple;
    do {
      apple = Offset(
          Random().nextInt(20).toDouble(), Random().nextInt(20).toDouble());
    } while (snake.contains(apple)); // Vérifie si la pomme est sur le serpent
    return apple;
  }

  Widget directionButtons() {
    return Column(
      children: [
        // Flèche Haut
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                changeDirection(const Offset(0, -1)); // Haut
              },
            ),
          ],
        ),
        // Flèches Gauche et Droite
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                changeDirection(const Offset(-1, 0)); // Gauche
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                changeDirection(const Offset(1, 0)); // Droite
              },
            ),
          ],
        ),
        // Flèche Bas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                changeDirection(const Offset(0, 1)); // Bas
              },
            ),
          ],
        ),
      ],
    );
  }
}
