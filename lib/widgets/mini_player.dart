import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
//import 'full_player_screen.dart'; // posible pantalla

class MiniPlayer extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const MiniPlayer({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   // Expandirse al tocar
      //   Navigator.push(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => FullPlayerScreen(audioPlayer: audioPlayer),
      //       transitionsBuilder: (_, animation, __, child) {
      //         return FadeTransition(opacity: animation, child: child);
      //       },
      //     ),
      //   );
      // },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        height: 70,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://placekitten.com/200/200',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Nombre de la canción',
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    playing ? audioPlayer.pause() : audioPlayer.play();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
