import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_ep3/models/myaccount.dart';
import 'package:flutter_app_ep3/utils/service_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_app_ep3/views/insert_my_account_ui.dart';
import 'package:flutter_app_ep3/views/up_det_my_account_ui.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  //ตัวแปรที่เก็บค่าที่ได้จากการเรียกใช้ serviceGetAllMyAccount()
  Future<List<MyAccount>> futureMyAccount;

  //เมธอดที่เรียกใช้งาน serviceGetAllMyAccount
  getAllMyAccount() async{
    futureMyAccount = serviceGetAllMyAccount();
  }

  //เมธอดแปลงรูปแบบของวันที่แบบไทย
  String changeDeteFormat(String dt){
      //subString ตั้งเเต่ตัวที่ index 0 ไปที่ index 4
      String year = dt.substring(0, 4);
      //subString ตั้งเเต่ตัวที่ index 5 ไปที่ index 7
      String month = dt.substring(5, 7);
      String day = dt.substring(8);

    year = (int.parse(year) + 543).toString();
    switch(int.parse(month)){
        case 1 : month = "มกราคม"; break;
        case 2 : month = "กุมภาพันธ์"; break;
        case 3 : month = "มีนาคม"; break;
        case 4 : month = "เมษายน"; break;
        case 5 : month = "พฤศภาคม"; break;
        case 6 : month = "มิถุนายน"; break;
        case 7 : month = "กรกฏาคม"; break;
        case 8 : month = "สิงหาคม"; break;
        case 9 : month = "กันยายน"; break;
        case 10 : month = "ตุลาคม"; break;
        case 11 : month = "พฤศจิกายน"; break;
        case 12 : month = "ธันวาคม"; break;
    }
    return day + ' ' + month + ' พ.ศ. ' + year;

  }

  @override
  void initState() {
      super.initState();
      getAllMyAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Account Diary 2010',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InsertMyAccountUi(),
            ),
          ).then((value){
            setState(() {
              getAllMyAccount();
            });
          });
        },
        backgroundColor: Color(0xff457373),
        icon: Icon(
          Icons.add,
        ),
        label: Text(
          'เพิ่มข้อมูล',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),
        ),
      ),
      body: futureMyAccount == null
      ?
          Center(
            child: Container(
              color: Colors.red,
              child: Text(
                'กรุณาลองใหม่อีกครั้ง....',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
          :
          FutureBuilder<List<MyAccount>>(
            future: futureMyAccount,
            builder: (context, snapshop){
              switch(snapshop.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                default:
                  {
                    if(snapshop.hasData){
                      if(snapshop.data[0].message == '1'){
                        return ListView.separated(
                          separatorBuilder: (context, index){
                            return Container(
                              height: 1.0,
                              width: double.infinity,
                              color: Color(0xff457373),
                            );
                          },
                          //กำหนดจำนวณรายการที่จะแสดงใน listview
                          itemCount: snapshop.data.length,
                          //แสดงเเต่ะรายการใน listview
                          itemBuilder: (context, index){
                            return ListTile(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context){
                                      return UpDetMyAccountUi(
                                        snapshop.data[index].mId,
                                        snapshop.data[index].mName,
                                        snapshop.data[index].mImages,
                                        snapshop.data[index].mQuantity,
                                        snapshop.data[index].mPay

                                      );
                                    }
                                  )
                                ).then((value){
                                  setState(() {
                                    getAllMyAccount();
                                  });
                                });
                              },
                              leading: CachedNetworkImage(
                                imageUrl: '${urlService}/accountdiry/${snapshop.data[index].mImages}',
                                width: 50,
                                height: 50,
                                imageBuilder: (context, imageProvider){
                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              title: Text(
                                '${snapshop.data[index].mName}'
                              ),
                              subtitle: Text(
                                changeDeteFormat(snapshop.data[index].mDate)
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                              ),
                            );
                          },

                        );
                      }else if(snapshop.data[0].message == '2'){
                        return Center(
                          child: Container(
                            color: Colors.red,
                            child: Text(
                              'กรุณาลองใหม่อีกครั้ง....(A)',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        );
                      }else{
                        return Center(
                          child: Container(
                            color: Colors.red,
                            child: Text(
                              'กรุณาลองใหม่อีกครั้ง....(A4)',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        );
                      }
                    }else{
                      return Center(
                        child: Container(
                          color: Colors.red,
                          child: Text(
                            'กรุณาลองใหม่อีกครั้ง....(B)',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }
                  }
              }
            },
          ),

    );
  }
}
