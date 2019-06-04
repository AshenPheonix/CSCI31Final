
<create>
  <form>
    <fieldset>
      <legend>Enter your Post here {opts.user}</legend>
      <div class="form-group">
        <label for="title">Post Title</label>
        <input type="text" class="form-control" id="title" placeholder="Title">
      </div>
      <div class="form-group">
        <label for="body">Post Body</label>
        <textarea id="postbody"> </textarea>
      </div>
      <button type="button" class="col-md-4" id="subbut" onclick={submit}>Create post</button>
      <span class="col-md-8" id="Error-Field" hidden={!error}></span>
    </fieldset>
  </form>

  <script>
    this.on("mount", () => {
      tinymce.init({
        selector:'#postbody'
      })
    })
    this.error=false;
    submit(e){
      console.log('clicked')
      var bad=document.getElementById('Error-Field')
      if(document.getElementById('title')=="" || tinymce.activeEditor.getContent()==""){
        bad.innerText='Please fill out the form'
        this.error=true;
        this.update();
      }else {
        var temp={
          post_body:tinymce.activeEditor.getContent(),
          post_title:document.getElementById('title').value,
          username:opts.user
        }
        socket.emit('posts:Create',temp);
        socket.once('post-cre-fin',(data) => {
          if (data.result==true) {
            bad.innerText='Post Added'
            this.update();
            riot.route('/','APG/Blog Home');
          }else {
            bad.innerText='Something errored'
            this.update();
          }
        })
      }
    }
  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</create>
