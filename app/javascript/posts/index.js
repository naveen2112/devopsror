$(document).ready(function () {
    if ($("#paginate-infinite-scrolling .pagination").length) {
        $(window).scroll(function () {
            if(window.pagination_loading){
                return;
            }
            var url;
            url = $("#paginate-infinite-scrolling .pagination .next_page").attr("href");
            if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
                window.pagination_loading = true
                $.getScript(url).always(function() {
                    return window.pagination_loading = false;
                });
            }
        });
    }
})

$(document).on('click', ".post-info", (function () {

    if ($(this).parent().attr("class").split(" ").includes('show-post-option')) {
        $(this).parent().removeClass("show-post-option")
    } else {
        $('.post-info').each(function(){
            $(this).parent().removeClass("show-post-option")
        });
        $(this).parent().addClass("show-post-option")
    }
}))