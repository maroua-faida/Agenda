


class Appointement {
//
// int id;
  String patient;
  String? date;
  String? startTime;
  String? endTime;
  String? agenda;
  String? reason;
  String? physician;
  String? comment;


   Appointement({  required this.patient,
      this.date,  this.startTime, this.endTime,  this.agenda,  this.reason,  this.physician, this.comment});



  static Map<dynamic, List<Appointement>> _appointmentsMap  = {};

  Map<String, dynamic> toJson() {
    return {
      'patient': patient,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'agenda': agenda,
      'reason': reason,
      'physician': physician,
      'other_comment':comment,

      // Add more properties as needed
    };
  }



  @override


  String toString() => '${this.patient}  '
      ' ${date}  ${this.startTime} ${this.endTime} ${this.agenda} ${this.reason} ${this.physician} ${this.comment} ' ;


}

