$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      height: 300
      width: '100%';
      placeholder: '投稿内容',
      toolbar: [
                ["table", ["table"]],
                ["style", ["style"]],
                ["fontsize"],
                ["color", ["color"]],
                ["style", ["bold", "italic", "underline", "clear"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["help", ["help"]]
             ]