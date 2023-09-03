class ExpenseItem {
  String price;
  String expense;
  String dateTime;

  ExpenseItem(this.price, this.expense, this.dateTime);

  ExpenseItem.fromJson(Map<String, dynamic> json)
      : price = json['price'],
        expense = json['expense'],
        dateTime = json['dateTime'];

  Map<String, dynamic> toJson() => {
        'price': price,
        'expense': expense,
        'dateTime': dateTime,
      };
}