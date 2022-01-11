$(document).on('turbolinks:load', function () {
    $('.selected_tag').hide();
    //tags List Start
    var customSelectTags;
    //converting data into json value
    var TagIds = $('#customSelectTag');
    var tagsList = TagIds.html();
    var dropDownList = [];
    var object = {
        "name": "Tag",
        "value": "Tag",
        "className": "tag-list",
        ["Tag"]: []
    };
    dropDownList.push(object);

    $(tagsList).each(function () {
        if ($(this).html()) {
            var optionText = $(this).html();
            var optionValue = $(this).val();
            var optionClass = 'class-' + optionValue + optionText.replace(/ /g, '');
            var object = {
                "name": optionText,
                "value": optionValue,
                "className": optionClass
            };
            dropDownList[0]['Tag'].push(object);
        }
    });
    customSelectTags = TagIds.customSelect({
        btnLabel: "Select Tags",
        inputType: "checkbox",
        AppendText: false,
        SearchPlaceHolder: "Search Tags",
        groupList: false,
        DropDownList: dropDownList,
        defaultSelectArray: [],
        onSelectFunction: function (list, value) {

            var tags_ids = []
            var tag_name = []
            $.each(value.Tag, function (index, value) {
                if ($.isNumeric(value)) {
                    tags_ids.push(value)
                } else {
                    var number = Math.floor((Math.random() * 10) + 1);
                    var company_id = $("#tag-company-id").val()
                    tag_name.push(value)
                    $("#new-tags-name").append(`<input type='hidden' value='${value}' name='post[tags_attributes][${number}][name]'> <br>
                 <input type="hidden"  value='${company_id}' name='post[tags_attributes][${number}][company_id]' >`)
                }
            })

            $("#posts-tags-ids").val(tags_ids)

            getSelectedTags(list)
        }
    });

    function getSelectedTags(list) {
        if (Object.keys(list).includes('Tag')) {
            $('.selected_tag').show();
            $('#selected_tag').empty();
            $.each(list.Tag, function (index, value) {
                $('#selected_tag').append('<div class="badge badge-primary"><span>' + value +
                    '</span><span class="close_icon"><svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.80471 7.86216C9.06538 8.12283 9.06538 8.54416 8.80471 8.80483C8.67471 8.93483 8.50404 9.00016 8.33337 9.00016C8.16271 9.00016 7.99204 8.93483 7.86204 8.80483L7.00004 7.94283L6.13804 8.80483C6.00804 8.93483 5.83737 9.00016 5.66671 9.00016C5.49604 9.00016 5.32537 8.93483 5.19537 8.80483C4.93471 8.54416 4.93471 8.12283 5.19537 7.86216L6.05737 7.00016L5.19537 6.13816C4.93471 5.8775 4.93471 5.45616 5.19537 5.1955C5.45604 4.93483 5.87737 4.93483 6.13804 5.1955L7.00004 6.0575L7.86204 5.1955C8.12271 4.93483 8.54404 4.93483 8.80471 5.1955C9.06538 5.45616 9.06538 5.8775 8.80471 6.13816L7.94271 7.00016L8.80471 7.86216ZM7.00004 0.333496C3.32404 0.333496 0.333374 3.32416 0.333374 7.00016C0.333374 10.6762 3.32404 13.6668 7.00004 13.6668C10.676 13.6668 13.6667 10.6762 13.6667 7.00016C13.6667 3.32416 10.676 0.333496 7.00004 0.333496Z" fill="#82CBFB"/></svg></span></div>')
            })
            $('#selected_tag .close_icon').on('click', function () {
                var deleteTag = $(this).prev().html()
                customSelectTags.removeSelectAllFunction(false, deleteTag);
            })
        } else {
            $('.selected_tag').hide();
        }
    }

    // tag list End

    //team List Start
    var customSelectTeams;
    //converting data into json value
    var TeamIds = $('#customSelectTeam');
    var teamList = TeamIds.html();
    var dropDownList = [];
    var object = {
        "name": "Team",
        "value": "Team",
        "className": "team-list",
        ["Team"]: []
    };
    dropDownList.push(object);

    $(teamList).each(function () {
        if ($(this).html()) {
            var optionText = $(this).html();
            var optionValue = $(this).val();
            var optionClass = 'class-' + optionValue + optionText.replace(/ /g, '');
            var object = {
                "name": optionText,
                "value": optionValue,
                "className": optionClass
            };
            dropDownList[0]['Team'].push(object);
        }
    });
    customSelectTeams = TeamIds.customSelect({
        btnLabel: "Select Team",
        inputType: "checkbox",
        AppendText: false,
        SearchPlaceHolder: "Search Team",
        groupList: false,
        DropDownList: dropDownList,
        defaultSelectArray: [],
        onSelectFunction: function (list, value) {
            getSelectedValue(list)
        }
    });

    function getSelectedValue(list) {
        if (Object.keys(list).includes('Team')) {
            $('#selected_team').empty();
            $.each(list.Team, function (index, value) {
                $('#selected_team').append('<div class="badge badge-primary"><span>' + value + '</span><span class="close_icon"><svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.80471 7.86216C9.06538 8.12283 9.06538 8.54416 8.80471 8.80483C8.67471 8.93483 8.50404 9.00016 8.33337 9.00016C8.16271 9.00016 7.99204 8.93483 7.86204 8.80483L7.00004 7.94283L6.13804 8.80483C6.00804 8.93483 5.83737 9.00016 5.66671 9.00016C5.49604 9.00016 5.32537 8.93483 5.19537 8.80483C4.93471 8.54416 4.93471 8.12283 5.19537 7.86216L6.05737 7.00016L5.19537 6.13816C4.93471 5.8775 4.93471 5.45616 5.19537 5.1955C5.45604 4.93483 5.87737 4.93483 6.13804 5.1955L7.00004 6.0575L7.86204 5.1955C8.12271 4.93483 8.54404 4.93483 8.80471 5.1955C9.06538 5.45616 9.06538 5.8775 8.80471 6.13816L7.94271 7.00016L8.80471 7.86216ZM7.00004 0.333496C3.32404 0.333496 0.333374 3.32416 0.333374 7.00016C0.333374 10.6762 3.32404 13.6668 7.00004 13.6668C10.676 13.6668 13.6667 10.6762 13.6667 7.00016C13.6667 3.32416 10.676 0.333496 7.00004 0.333496Z" fill="#82CBFB"/></svg></span></div>')
            })
            $('#selected_team .close_icon').on('click', function () {
                var deleteVal = $(this).prev().html();
                customSelectTeams.removeSelectAllFunction(false, deleteVal);
            })
        }
    }

    // Team list End

    //post Tag Start
    $('.tags-list').hide();
    var customSelectPostTags;
    //converting data into json value
    var PostTagIds = $('#customSelectPostTag');
    var postTagsList = PostTagIds.html();
    var dropDownList = [];
    var object = {
        "name": "Tag",
        "value": "Tag",
        "className": "tag-list",
        ["Tag"]: []
    };
    dropDownList.push(object);

    $(postTagsList).each(function () {
        if ($(this).html()) {
            var optionText = $(this).html();
            var optionValue = $(this).val();
            var optionClass = 'class-' + optionValue + optionText.replace(/ /g, '');
            var object = {
                "name": optionText,
                "value": optionValue,
                "className": optionClass
            };
            dropDownList[0]['Tag'].push(object);
        }
    });
    customSelectPostTags = PostTagIds.customSelect({
        btnLabel: "Select Tags",
        inputType: "checkbox",
        AppendText: false,
        SearchPlaceHolder: "Search Tags",
        groupList: false,
        DropDownList: dropDownList,
        defaultSelectArray: [],
        onSelectFunction: function (list, value) {
            filterTags(value)
            getSelectedPostTags(list)
        }
    });

    function getSelectedPostTags(list) {
        if (Object.keys(list).includes('Tag')) {
            $('.tags-list').show();
            $('#selected_post_tag').empty();
            $.each(list.Tag, function (index, value) {
                $('#selected_post_tag').append('<div class="badge badge-primary"><span>' + value +
                    '</span><span class="close_icon"><svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M8.80471 7.86216C9.06538 8.12283 9.06538 8.54416 8.80471 8.80483C8.67471 8.93483 8.50404 9.00016 8.33337 9.00016C8.16271 9.00016 7.99204 8.93483 7.86204 8.80483L7.00004 7.94283L6.13804 8.80483C6.00804 8.93483 5.83737 9.00016 5.66671 9.00016C5.49604 9.00016 5.32537 8.93483 5.19537 8.80483C4.93471 8.54416 4.93471 8.12283 5.19537 7.86216L6.05737 7.00016L5.19537 6.13816C4.93471 5.8775 4.93471 5.45616 5.19537 5.1955C5.45604 4.93483 5.87737 4.93483 6.13804 5.1955L7.00004 6.0575L7.86204 5.1955C8.12271 4.93483 8.54404 4.93483 8.80471 5.1955C9.06538 5.45616 9.06538 5.8775 8.80471 6.13816L7.94271 7.00016L8.80471 7.86216ZM7.00004 0.333496C3.32404 0.333496 0.333374 3.32416 0.333374 7.00016C0.333374 10.6762 3.32404 13.6668 7.00004 13.6668C10.676 13.6668 13.6667 10.6762 13.6667 7.00016C13.6667 3.32416 10.676 0.333496 7.00004 0.333496Z" fill="#82CBFB"/></svg></span></div>')
            })
            $('#selected_post_tag .close_icon').on('click', function () {
                var deleteTag = $(this).prev().html()
                customSelectPostTags.removeSelectAllFunction(false, deleteTag);
            })
        } else {
            $('.tags-list').hide();
        }
    }

    function filterTags(value) {

        $.ajax({
            url: "/posts",
            method: "get",
            dataType: 'script',
            data: {tag_ids: value.Tag}
        });
    }

    //post Tag End
});