/* Loading Script */
$(window).load(function () {
    $(".loader").delay(500).fadeOut();
    $("#mask").delay(1000).fadeOut("slow");

    //NProgress.configure({ easing: 'fade', speed: 500 });
    $('body').show();
    $('.version').text(NProgress.version);
    NProgress.start();
    setTimeout(function() { NProgress.done(); $('.fade').removeClass('out'); }, 1000);

});

/* Home page slider */
$(window).load(function () {
    "use strict";
    $("#owl-main-text").owlCarousel({
        autoPlay: 9999999999,
        goToFirst: true,
        goToFirstSpeed: 99999999999,
        navigation: false,
        slideSpeed: 700,
        pagination: false,
        transitionStyle: "fadeUp",
        singleItem: true
            // "singleItem:true" is a shortcut for:
            // items : 1,
            // itemsDesktop : false,
            // itemsDesktopSmall : false,
            // itemsTablet: false,
            // itemsMobile : false
    });
});

/* Home background slider */
$(window).load(function () {
    "use strict";
    $("#owl-main").owlCarousel({
        autoPlay: 5000,
        navigation: true,
        slideSpeed: 400,
        pagination: false,
        transitionStyle: "fade",
        singleItem: true
            // "singleItem:true" is a shortcut for:
            // items : 1,
            // itemsDesktop : false,
            // itemsDesktopSmall : false,
            // itemsTablet: false,
            // itemsMobile : false
    });
});

/* Nav menu */
$(document).ready(function () {
    "use strict";
    $('.navigation').onePageNav({
        filter: ':not(.external)'
    });
});

/* Sticky Header
$(document).ready(function () {
    "use strict";
    $("header").sticky({
        topSpacing: 0
    });
});*/

/* Scroll plugin */
$(document).ready(function () {
    "use strict";
    $('nav li').localScroll();
    $('.slider-wrap').localScroll();
    $('.top-profile').localScroll();
});

$(document).ready(function () {
    // scroll to top and show top content
    $('#how_it_work').on('click', function () {
        $('html, body').stop().animate({
            scrollTop: 0
        }, 300, function () {
            $('#how_it_work_top_bar').slideDown(500);
        });
    });

    // hide top content on click close icon
    $('#close_top_bar').on('click', function () {
        $('#how_it_work_top_bar').slideUp(300);
    });
    resizePage();
});

$(window).scroll(function () {
    // hide top content when scroll position is top of content
    if ($('#how_it_work').length > 0 && $(this).scrollTop() > $('#how_it_work').position().top) {
        if ($('#how_it_work_top_bar').css('display') !== 'none') {
            $('#how_it_work_top_bar').slideUp(0);
            $('html, body').stop().animate({
                scrollTop: 0
            }, 0);
        }
    }
});

$(window).resize(resizePage);

function resizePage() {
  var child_el = $('.v-center').height()
  $('#login-form').height(child_el)
}
