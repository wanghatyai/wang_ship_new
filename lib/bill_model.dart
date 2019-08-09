class Bill{
  final String shipBillId;
  final String shipBillCode1;
  final String shipBillCode2;
  final String shipBillCode3;
  final String shipBillCodeCom1;
  final String shipBillCodeCom2;
  final String shipBillCodeCom3;
  final String shipBillCusID;
  final String shipBillCusCode;
  final String shipBillCusName;
  final String shipBillCusAddress;
  final String shipBillQty;
  final String shipBillShipStatus;
  final String shipBillWhoShip;
  final String shipBillPrintStatus;
  final String shipBillDateCreate;

  Bill({
    this.shipBillId,
    this.shipBillCode1,
    this.shipBillCode2,
    this.shipBillCode3,
    this.shipBillCodeCom1,
    this.shipBillCodeCom2,
    this.shipBillCodeCom3,
    this.shipBillCusID,
    this.shipBillCusCode,
    this.shipBillCusName,
    this.shipBillCusAddress,
    this.shipBillQty,
    this.shipBillShipStatus,
    this.shipBillWhoShip,
    this.shipBillPrintStatus,
    this.shipBillDateCreate
  });

  factory Bill.fromJson(Map<String, dynamic> json){
    return new Bill(
      shipBillId: json['id'],
      shipBillCode1: json['sIdBill'],
      shipBillCode2: json['sIdBill_2'],
      shipBillCode3: json['sIdBill_3'],
      shipBillCodeCom1: json['sIdBillc'],
      shipBillCodeCom2: json['sIdBillc_2'],
      shipBillCodeCom3: json['sIdBillc_3'],
      shipBillCusID: json['sIdCus'],
      shipBillCusCode: json['ccode'],
      shipBillCusName: json['name'],
      shipBillCusAddress: json['address'],
      shipBillQty: json['sQt'],
      shipBillShipStatus: json['Shipped'],
      shipBillWhoShip: json['sWhoShip'],
      shipBillPrintStatus: json['sPrinted'],
      shipBillDateCreate: json['sDateCreate'],
    );
  }

}