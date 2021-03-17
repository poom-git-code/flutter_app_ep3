import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class InsertMyAccountUi extends StatefulWidget {
  @override
  _InsertMyAccountUiState createState() => _InsertMyAccountUiState();
}

class _InsertMyAccountUiState extends State<InsertMyAccountUi> {

  File _selectImage;
  String _selectImageBase64;
  String _selectImageName;

  _selectImageFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    //ถ้า pickedFile ไม่มีรูปให้มัน return ออกไปเลย
    if(pickedFile == null) return;
    setState(() {
      //จะเอารุปจาก pickedFile มากำหนดให้กับ _selectImage
      _selectImage = File(pickedFile.path);
      //เเปลงรูปเป็น Base64 เก็บในตัวแปร _selectImageBase64
      _selectImageBase64 = base64Encode(_selectImage.readAsBytesSync());
      //ชื่อรูปเก็บในตัวแปร _selectImageName
      _selectImageName = _selectImage.path.split('/').last;
    });
  }

  _selectImageFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    //ถ้า pickedFile ไม่มีรูปให้มัน return ออกไปเลย
    if(pickedFile == null) return;
    setState(() {
      //จะเอารุปจาก pickedFile มากำหนดให้กับ _selectImage
      _selectImage = File(pickedFile.path);
      //เเปลงรูปเป็น Base64 เก็บในตัวแปร _selectImageBase64
      _selectImageBase64 = base64Encode(_selectImage.readAsBytesSync());
      //ชื่อรูปเก็บในตัวแปร _selectImageName
      _selectImageName = _selectImage.path.split('/').last;
    });
  }

  _showSelectFromCamGal(context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context){
        return Row(
          children: [
            Expanded(
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _selectImageFromCamera();
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.green[400],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _selectImageFromGallery();
                },
                child: Icon(
                  Icons.camera,
                  color: Colors.red,
                ),
              ),
          ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Account Diary 2010 (เพิ่ม)',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 28.0,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 2,
                          color: Colors.pink
                        )
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _selectImage == null ? AssetImage('assets/images/mylogo.png') : FileImage(_selectImage)
                        )
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                      ),
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: IconButton(
                          onPressed: (){
                            _showSelectFromCamGal(context);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'รายการที่จ่าย',
                      labelStyle: TextStyle(
                        color: Colors.teal,
                        fontSize: 25
                      ),
                      hintText: 'อาหาร ขนม น้ำดื่ม',
                      hintStyle: TextStyle(
                        color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.fastfood,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 15),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                    ],
                    decoration: InputDecoration(
                      labelText: 'จำนวน',
                      labelStyle: TextStyle(
                          color: Colors.teal,
                          fontSize: 25
                      ),
                      hintText: '0',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.format_list_numbered,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 15),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                      )
                    ],
                    decoration: InputDecoration(
                      labelText: 'เงินที่จ่าย',
                      labelStyle: TextStyle(
                          color: Colors.teal,
                          fontSize: 25
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(
                          color: Colors.grey[400]
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Colors.teal,
                      ),
                      suffixText: 'บาท'
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text(
                            'บันทึก',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          color: Colors.green[500],
                        ),
                      ),
                      SizedBox(width: 28,),
                      Expanded(
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                          color: Colors.red[500],
                        ),
                      ),
                    ],
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
