$(function(){
  //home page
  var se1 = $('.se1');
  var se2 = $('.se2');
  se1.val(se1.data('select-value'))
  se2.val(se2.data('select-value'))

  $("#query_form").validate({
    rules: {
      'ctl00$ContentPlaceHolder1$TextBoxClwfHphm': {
        required: true,
        rangelength: [6, 6]
      },
      'ctl00$ContentPlaceHolder1$txtFDJH': {
        required: true,
        rangelength: [5, 5]
      },
      'ctl00$ContentPlaceHolder1$txtWZCode': {
        required: true
      }
    },
    messages: {
      'ctl00$ContentPlaceHolder1$TextBoxClwfHphm': {
        required: '不能为空',
        rangelength: '长度必须为6'
      },
      'ctl00$ContentPlaceHolder1$txtFDJH': {
        required: '不能为空',
        rangelength: '长度必须为5'
      },
      'ctl00$ContentPlaceHolder1$txtWZCode': {
        required: '不能为空'
      }
    }
  });
  //end home page

});

