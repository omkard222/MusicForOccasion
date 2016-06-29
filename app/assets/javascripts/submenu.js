$('a#payment_method').on('click', function(e){
  $('div.content').load(this.href);
  e.preventDefault();
});

$('a#receiving_money').on('click', function(e){
  $('div.content').load(this.href);
  e.preventDefault();
});