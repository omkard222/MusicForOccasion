ready = function(){
  var dateToday = new Date();
  $('.datepicker').datetimepicker({ format:'d/m/Y H:i',
                                    minDate: dateToday
                                  });
};

$(document).ready(ready)
$(document).on('page:load', ready)
