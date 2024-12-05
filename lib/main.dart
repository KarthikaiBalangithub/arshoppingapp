import 'package:flutter/material.dart' hide Colors;
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart' as material show Colors;

void main() {
  runApp(const GBTApp());
}

class GBTApp extends StatelessWidget {
  const GBTApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBT App',
      theme: ThemeData(
        primarySwatch: material.Colors.blue,
      ),
      home: const GBTPage(),
    );
  }
}

class GBTPage extends StatelessWidget {
  const GBTPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GBT App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/your_image.png'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ARViewPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: material.Colors.black,
            foregroundColor: material.Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Show 3D Model'),
        ),),
    );
  }
}

class ARViewPage extends StatefulWidget {
  const ARViewPage({Key? key}) : super(key: key);

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
      ),
      body: ARView(
        onARViewCreated: onARViewCreated,
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    
    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );
    
    arObjectManager!.onInitialize();

    // Add 3D model
    var node = ARNode(
      type: NodeType.localGLTF2,
      uri: "assets/home.glb",
      scale: Vector3.all(0.1),
      position: Vector3(0.0, 0.0, -0.5),
      rotation: Vector4(1.0, 0.0, 0.0, 0.0),
    );
    
    arObjectManager!.addNode(node);
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}