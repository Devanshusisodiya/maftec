import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vca_app2/pages/upload.dart';

class Fscreen extends StatelessWidget {
  const Fscreen({Key? key}) : super(key: key);
  final String assetName = 'assets/logo.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          children: [
            // bit of gap above the logo
            const Divider(
              height: 100,
            ),
            // logo
            Container(
                height: 197.4,
                color: Colors.white,
                child: SvgPicture.asset(assetName)),
            // welcome message
            const Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Text(
                'Welcome to Maftec',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // enter button
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: ClipOval(
                child: Material(
                  color: Colors.grey, // Button color
                  child: InkWell(
                    splashColor: Colors.red, // Splash color
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Upload()));
                    },
                    child: const SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 60,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
