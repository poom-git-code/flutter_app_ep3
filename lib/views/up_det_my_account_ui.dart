import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ep3/utils/service_api.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class UpDetMyAccountUi extends StatefulWidget {

  String mId;
  String mName;
  String mImages;
  String mQuantity;
  String mPay;

  UpDetMyAccountUi(
      this.mId, this.mName, this.mImages, this.mQuantity, this.mPay);

  @override
  _UpDetMyAccountUiState createState() => _UpDetMyAccountUiState();
}

class _UpDetMyAccountUiState extends State<UpDetMyAccountUi> {

  //สร้างตัว controller ผูกกับ TextField
  TextEditingController mNameCtrl = TextEditingController();
  TextEditingController mQuantityCtrl = TextEditingController();
  TextEditingController mPayCtrl = TextEditingController();

  File _selectImage;
  String _selectImageBase64 = '';
  String _selectImageName = '';

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

  _showWarningDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'คำเตือน !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/mylogo.png',
                  width: 80,
                ),
                SizedBox(height: 15,),
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.black12,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xff457373),
          );
        }
    );
  }

  _showConfirmDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'คำเตือน !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        //ต้องส่งข้อมูลที่จะบันทึกไปที่ Service insert ไปที่ Server
                        //ผ่านทาง api ไปที่เราจะสร้าง
                        Navigator.pop(context);
                        String message = await serviceUpdateMyAccount(
                            widget.mId,
                            mNameCtrl.text,
                            _selectImageBase64,
                            mQuantityCtrl.text,
                            mPayCtrl.text,
                            _selectImageName
                        );
                        if(message == '1'){
                          //ถ้าเท่ากับ 1 ให้กลับไปหน้าเเรก
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                        else{
                          //แสดง dialog แจ้งบันทึกไม่สำเร็จ
                          _showInsertResultDialog('บันทึกไม่สำเร็จ');
                        }
                      },
                      color: Colors.black12,
                      child: Text(
                        'บันทึก (แก้ไข)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[600]
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    RaisedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      color: Colors.black12,
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[600]
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Color(0xff457373),
          );
        }
    );
  }

  _showInsertResultDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'ผลการบันทึก',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15,),
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: Colors.black12,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xff457373),
          );
        }
    );
  }

  _showConfirmDeleteDialog(String msg) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Center(
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'คำเตือน !!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        //ต้องส่งข้อมูลที่จะบันทึกไปที่ Service insert ไปที่ Server
                        //ผ่านทาง api ไปที่เราจะสร้าง
                        Navigator.pop(context);
                        String message = await serviceDeleteMyAccount(
                            widget.mId
                        );
                        if(message == '1'){
                          //ถ้าเท่ากับ 1 ให้กลับไปหน้าเเรก
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                        else{
                          //แสดง dialog แจ้งบันทึกไม่สำเร็จ
                          _showInsertResultDialog('ลบไม่สำเร็จ');
                        }
                      },
                      color: Colors.black12,
                      child: Text(
                        'ลบ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[600]
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    RaisedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      color: Colors.black12,
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red[600]
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            backgroundColor: Color(0xff457373),
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mNameCtrl.text = widget.mName;
    mQuantityCtrl.text = widget.mQuantity;
    mPayCtrl.text = widget.mPay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Diary 2010 (แก้ไข/ลบ)',
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
                    _selectImageName == ''
                    ?
                    CachedNetworkImage(
                      imageUrl: '${urlService}/accountdiry/${widget.mImages}',
                      width: 150,
                      height: 150,
                      imageBuilder: (context, imageProvider){
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
                            ),
                          ),
                        );
                      },
                    )
                    :
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
                    controller: mNameCtrl,
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
                    controller: mQuantityCtrl,
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
                    controller: mPayCtrl,
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
                          onPressed: (){
                            if(mNameCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนรายการที่จ่ายด้วย !!!');
                            }
                            else if(mQuantityCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนจำนวนด้วย !!!');
                            }
                            else if(mPayCtrl.text.trim().length == 0){
                              _showWarningDialog('ป้อนจำนวณเงินที่จ่ายด้วย !!!');
                            }
                            else{
                              //สีงข้อมูลไปให้ Service insert เพื่อบันทึกลงฐานข้อมูล
                              _showConfirmDialog('ต้องการแก้ไข้ข้อมูลหรือไม่ !!!');
                            }
                          },
                          child: Text(
                            'เเก้ไข้',
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
                          onPressed: () async {
                            _showConfirmDeleteDialog('ต้องการลบข้อมูลหรือไม่ !!!');
//                            Navigator.pop(context);
//                            String message = await serviceDeleteMyAccount(
//                              widget.mId,
//                            );
//                            if(message == '1'){
//                              //ถ้าเท่ากับ 1 ให้กลับไปหน้าเเรก
//                              Navigator.of(context).popUntil((route) => route.isFirst);
//                            }
//                            else{
//                              //แสดง dialog แจ้งบันทึกไม่สำเร็จ
//                              _showInsertResultDialog('บันทึก (แก้ไข้ไม่สำเร็จ)');
//                            }
                          },
                          child: Text(
                            'ลบ',
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
