import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app_ep3/models/myaccount.dart';

//ไฟล์นี้เอาไว้เขียนโค้ดเรียกใช้ service ต่างๆ ที่ server

//สร้างตัวแปรกลางเก็บ uel ของ server ที่เก็บ service ที่เราจะเรียกใช้
String urlService = "http://10.1.2.18:8080";

//เรียกใช้ service : serviceGetAllMyAccount.php ที่ server
Future<List<MyAccount>> serviceGetAllMyAccount() async{
  //ติดต่อ service เพื่อดึงข้อมูลมาใส่ใน app
  final response = await http.get(
    Uri.encodeFull('${urlService}/accountdiry/serviceGetALLMyAccount.php'),
    headers:{"Content-Type": "application/json"}
  );

  //เอาข้อมูลในตัวแปร response มาทำการแปลงข้อมูลที่เอามาใช้ใน app
  if(response.statusCode == 200){
    //เริ่มจาก decode ข้อมูล json
    final responseData = jsonDecode(response.body);
    //decode เสร็จก็นำมาแปลงข้อมูลแบบ List เพื่อนำไปใช้งาน
    final myaccountData = await responseData.map<MyAccount>((json){
      return MyAccount.fromJson(json);
    }).toList();
    //สุดท้ายส่งค่ากลับไปที่จุดที่เรียกใช้เมธอดนี้เพื่อนำไปใช้งาน
    return myaccountData;
  }else{
    return null;
  }
}

//สร้างเมธอดเรียนกใช้ Service : serviceInsertMyAccount
Future<String> serviceInsertMyAccount(String mName, String mImages, String mQuantity, String mPay, String imageName) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  MyAccount myAccount = MyAccount(
    mName: mName,
    mImages: mImages,
    mQuantity: mQuantity,
    mPay: mPay,
    imageName: imageName
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
    Uri.encodeFull('${urlService}/accountdiry/serviceInsertMyAccount.php'),
    body: json.encode(myAccount.toJson()),
    headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}

Future<String> serviceUpdateMyAccount(String mID, String mName, String mImages, String mQuantity, String mPay, String imageName) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  MyAccount myAccount = MyAccount(
      mId: mID,
      mName: mName,
      mImages: mImages,
      mQuantity: mQuantity,
      mPay: mPay,
      imageName: imageName
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
      Uri.encodeFull('${urlService}/accountdiry/serviceUpdateMyAccount.php'),
      body: json.encode(myAccount.toJson()),
      headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}

Future<String> serviceDeleteMyAccount(String mID) async{
  //นำค่าที่จะส่งไปบันทึกที่ Server มารวมกันเป็นออฟเจ็กต์
  MyAccount myAccount = MyAccount(
      mId: mID
  );

  //ส่งข้อมูลไป Server ผ่าน Service insert
  final response = await http.post(
      Uri.encodeFull('${urlService}/accountdiry/serviceDeleteMyAccount.php'),
      body: json.encode(myAccount.toJson()),
      headers: {"Content-Type": "application/json"}
  );

  //เอาทผลี่ส่งกลับมาส่งกลับไปยังจุดเรียกใช้เพื่อนำข้อมูลที่ส่งกลับมาไปใช้งาน
  if(response.statusCode == 201){
    final resData = json.decode(response.body);
    return resData['message'];
  }
  else{
    return null;
  }
}