
$(document).on('turbolinks:load', ()=> {

  const buildFileField = (index)=> {
    const html = `<div data-index="${index}" class="js-file_group">
                    <div class= "js-file">
                      <label>
                        <input class= "field-hidden" type="file" name="item[images_attributes][${index}][item_image]" id="item_images_attributes_${index}_item_image">
                        <i class="fas fa-camera fa-2x"></i>
                      </label>
                    </div>
                    <div class="js-remove">削除</div>
                  </div>`;
    return html;
  }
  const buildImg = (index, url)=> {
    const html = `<img data-index="${index}" src="${url}" width="100px" height="100px">`;
    return html;
  }

  // file_fieldのnameに動的なindexをつける為の配列
  let fileIndex = [1,2,3,4,5,6,7,8,9,10];
  // 既に使われているindexを除外
  lastIndex = $('.js-file_group:last').data('index');
  fileIndex.splice(0, lastIndex);
  $('.hidden-destroy').hide();

  $('#image-select').on('change', '.js-file', function(e) {
    const targetIndex = $(this).parent().data('index');
    // ファイルのブラウザ上でのURLを取得する
    const file = e.target.files[0];
    const blobUrl = window.URL.createObjectURL(file);
    // 該当indexを持つimgタグがあれば取得して変数imgに入れる(画像変更の処理)
    if (img = $(`img[data-index="${targetIndex}"]`)[0]) {
      img.setAttribute('src', blobUrl);
    } else {  // 新規画像追加の処理
      $('#previews').append(buildImg(targetIndex, blobUrl));
      // fileIndexの先頭の数字を使ってinputを作る
      $('#image-select').append(buildFileField(fileIndex[0]));
      $('.js-remove').last().hide()
      fileIndex.shift();
      // 末尾の数に1足した数を追加する
      fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
    }
    $(this).next('.js-remove').show();
    $(this).hide();
  });

  $('#image-select').on('click', '.js-remove', function() {
    const targetIndex = $(this).parent().data('index');
    // 該当indexを振られているチェックボックスを取得する
    const hiddenCheck = $(`input[data-index="${targetIndex}"].hidden-destroy`);
    // もしチェックボックスが存在すればチェックを入れる
    if (hiddenCheck) hiddenCheck.prop('checked', true);


    $(this).parent().remove();
    $(`img[data-index="${targetIndex}"]`).remove();
    if ($('.js-file').length == 0) $('#image-select').append(buildFileField(fileIndex[0]));
  });
});