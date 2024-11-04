import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      await _getCurrentLocation();
    } else {
      // 권한이 없을 경우 처리
      print('위치 권한이 필요합니다.');
      // 사용자에게 권한 요청 실패 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 권한이 필요합니다.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });

      // 카메라를 현재 위치로 이동
      mapController.animateCamera(
        CameraUpdate.newLatLng(currentPosition!),
      );
    } catch (e) {
      print('현재 위치를 가져오는 데 실패했습니다: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('현재 위치를 가져오는 데 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이 위치'),
        leading: IconButton(
          icon: Image.asset('assets/img/back.png'), // 뒤로가기 이미지 경로
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0), // 초기 위치는 기본값으로 설정
          zoom: 2, // 지도를 전 세계가 보이도록 줌 레벨 설정
        ),
        markers: currentPosition != null
            ? {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentPosition!,
            infoWindow: const InfoWindow(title: '아이 위치'),
          ),
        }
            : {},
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
