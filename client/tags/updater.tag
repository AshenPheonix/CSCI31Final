
<updater>
  <form>
    <div class="form-group">
      <label for="username">User Name</label>
      <input type="text" class="form-control" id="username" placeholder={username}>
    </div>

    <div if={opts.which=='post'}>
      <div class="form-group">
        <label for="title">Title</label>
        <input type="text" class="form-control" id="title" placeholder={title}>
      </div>
      <textarea id="body" rows="20"></textarea>
    </div>

    <div if={opts.which=='user'}>
      <div class="form-group">
        <label for="firstname">First Name</label>
        <input type="text" class="form-control" id="firstname" placeholder={name_f}>
      </div>
      <div class="form-group">
        <label for="lastname">Last Name</label>
        <input type="text" class="form-control" id="lastname" placeholder={name_l}>
      </div>

    </div>
    <br><br>
    <button type="button" onclick={submit}>Change</button>
  </form>
  <script>
    this.on("mount", () => {
      if (opts.which=='post') {
        socket.emit('posts:ViewOne',{pageID:opts.core.post_id})
        socket.once('fetched-one',(post)=>{
          this.username=post.username
          this.body=post.post_body
          this.title=post.post_title
          tinymce.init({
            selector:'#body'
          })
          tinymce.activeEditor.setContent(post.post_body)
          this.update();
        })
      } else {
        this.username=opts.core.username
        this.name_f=opts.core.name_f
        this.name_l=opts.core.name_l
        this.is_admin=opts.core.isadmin
      }
      this.update();
    })
    submit(e){
      var temp={
        username:this.username,
        updates:{}
      }
      if(document.getElementById('username').value!="")
        temp.updates.username=document.getElementById('username').value
      if(opts.which=='post'&&document.getElementById('title').value!="")
        temp.updates.post_title=document.getElementById('title').value
      if(opts.which=='post')
        temp.updates.post_body=tinymce.activeEditor.getContent();
      if (opts.which=='user'&&document.getElementById('firstname').value!="") {
        temp.updates.name_f=document.getElementById('firstname').value
      }
      if(opts.which=='user'&&document.getElementById('lastname').value!=""){
        temp.updates.name_l=document.getElementById('lastname').value
      }
      if (opts.which=='post') {
        temp.post_id=opts.core.post_id
        socket.emit('posts:Update',temp)
      }
      if (opts.which=='user') {
        socket.emit('users:Update',temp)
      }
      socket.once('finished',(res)=>{
        if(res.result&&opts.which=='user'){
          socket.emit('users:View')
          socket.once('view-fin',(data) => {
            opts.parent.users=data;
            opts.parent.update();
            document.getElementById('user_done').hidden=false;
            this.unmount();
          })
        }else if (res.result&&opts.which=='post') {
          socket.emit('posts:ViewAll')
          socket.once('fetched',(data) => {
            opts.parent.posts=data;
            opts.parent.update()
            this.unmount();
          })
        }
      })
    }
  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</updater>
