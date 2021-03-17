//ไฟล์นี้เป็นไฟล์ที่ใช้ในการจักการข้อมูลระหว่าง mobile กับ service
//จัดการอะไร???
//1. แปลงข้อมูลที่ได้รับจาก service ซึ่งเป็น json ให้เป็นข้อมูลที่ไปใช้ได้ใน app
//2. แปลงข้อมูลใน app เป็น json เพื่อส่งไปที่ service ที่ server

class MyAccount {
  String message;
  String mId;
  String mName;
  String mImages;
  String mQuantity;
  String mPay;
  String mDate;
  String imageName;

  MyAccount(
      {this.message,
        this.mId,
        this.mName,
        this.mImages,
        this.mQuantity,
        this.mPay,
        this.mDate,
        this.imageName
      });

  MyAccount.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    mId = json['mId'];
    mName = json['mName'];
    mImages = json['mImages'];
    mQuantity = json['mQuantity'];
    mPay = json['mPay'];
    mDate = json['mDate'];
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['mId'] = this.mId;
    data['mName'] = this.mName;
    data['mImages'] = this.mImages;
    data['mQuantity'] = this.mQuantity;
    data['mPay'] = this.mPay;
    data['mDate'] = this.mDate;
    data['imageName'] = this.imageName;
    return data;
  }
}