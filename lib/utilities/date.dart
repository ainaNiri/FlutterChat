import 'package:intl/intl.dart';

String getDate(String lastMessageDate){
  var now = DateTime.now();
  if(now.year.compareTo(DateTime.parse(lastMessageDate).year) == 1){
    return DateFormat.yMMMMd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.month.compareTo(DateTime.parse(lastMessageDate).month) == 1 && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inDays) > 15){
    return DateFormat.MMMEd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if((now.day.compareTo(DateTime.parse(lastMessageDate).day) == 1 || now.day.compareTo(DateTime.parse(lastMessageDate).day) == -1) 
     && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inHours) > 23){
    return (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inDays).toString() + " days ago";
  }
  if((-DateTime.parse(lastMessageDate).difference(DateTime.now()).inHours) >= 1 || now.hour.compareTo(DateTime.parse(lastMessageDate).hour) == -1){
    return (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inHours).toString() + " hours ago";
  }
  
  return DateTime.parse(lastMessageDate).hour.toString() + ":"  +DateTime.parse(lastMessageDate).minute.toString();
}

String dateDifference(String lastMessageDate){
  var now = DateTime.now();
  if(now.year.compareTo(DateTime.parse(lastMessageDate).year) == 1){
    return DateFormat.yMMMMd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.month.compareTo(DateTime.parse(lastMessageDate).month) == 1 && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inDays) > 15){
    return DateFormat.MMMEd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if((now.day.compareTo(DateTime.parse(lastMessageDate).day) == 1 || now.day.compareTo(DateTime.parse(lastMessageDate).day) == -1) 
     && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inHours) > 23){
    return DateFormat.MMMEd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.hour.compareTo(DateTime.parse(lastMessageDate).hour) == 1){
    return DateFormat.Hm().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.hour.compareTo(DateTime.parse(lastMessageDate).hour) == -1)
    return "Yesterday, " +  DateFormat.Hm().format(DateTime.parse(lastMessageDate)).toString();

  return "";
}

String printDate(String lastMessageDate){
  var now = DateTime.now();
  if(now.year.compareTo(DateTime.parse(lastMessageDate).year) == 1){
    return DateFormat.yMMMMd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.month.compareTo(DateTime.parse(lastMessageDate).month) == 1 && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inDays) > 15){
    return DateFormat.MMMEd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if((now.day.compareTo(DateTime.parse(lastMessageDate).day) == 1 || now.day.compareTo(DateTime.parse(lastMessageDate).day) == -1) 
     && (-DateTime.parse(lastMessageDate).difference(DateTime.now()).inHours) > 23){
    return DateFormat.MMMEd().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.hour.compareTo(DateTime.parse(lastMessageDate).hour) == 1){
    return DateFormat.Hm().format(DateTime.parse(lastMessageDate)).toString();
  }
  if(now.hour.compareTo(DateTime.parse(lastMessageDate).hour) == -1)
    return "Yesterday, " +  DateFormat.Hm().format(DateTime.parse(lastMessageDate)).toString();

  return DateFormat.Hm().format(DateTime.parse(lastMessageDate)).toString();;
}