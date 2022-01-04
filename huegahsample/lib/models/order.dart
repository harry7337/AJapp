import 'package:huegahsample/models/buyer.dart';
import 'package:huegahsample/models/seller.dart';

class Order {
  final String _id;
  final Seller _seller;
  final Buyer _buyer;
  final DateTime _issueDate;
  DateTime _deliveryDate;
  DateTime _expectedDeliveryDate;

  Order(this._id, this._seller, this._buyer, this._issueDate);
}
