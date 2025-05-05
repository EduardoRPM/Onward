import 'package:flutter/material.dart';
import 'package:onward/welcome.dart';
import 'constantes.dart';

import 'constantes.dart';
import 'screens/medallas.dart';

class Iniciosesion extends StatefulWidget {
  const Iniciosesion({super.key});

  @override
  State<Iniciosesion> createState() => _welcomeState();
}

class _welcomeState extends State<Iniciosesion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/inicioSesion.webp',
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
          ),
          // Botón en la esquina superior izquierda
          Positioned(
            top: 426,
            left: 0,
            right: 0, // Esto expande horizontalmente
            child: Center( // Esto centra el hijo horizontalmente
              child: SizedBox(
                width: 275,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color2,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email, color: Colors.grey,),
                            hintText: 'Correo electrónico' ,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,


                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 15), // Ajusta la alineación vertical
                          )

                        )
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                              textAlign: TextAlign.end,
                              obscureText: true, // Oculta el texto mientras lo escribes
                              style: TextStyle(

                                color: Colors.black,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.visibility, color: Colors.grey,),
                                hintText: 'Password' ,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,


                                ),
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 15), // Ajusta la alineación vertical

                              )

                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 0, left: 110, right: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        child: SizedBox(
                          width: 120,
                          height: 31,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Para que respete el tamaño exacto
                              backgroundColor: Color1,

                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Medallas()),
                              );
                            },
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ), // Puedes ajustar el tamaño del texto

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),







        ],
      ),
    );
  }
}
