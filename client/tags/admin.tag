
<admin>
  <p class="align-center">
    Users
  </p>
  <table class="table table-bordered table-striped table-hover table-responsive" id="display-table">
    <tr>
      <th>
        UserName
      </th>
      <th>
        Password(hashed)
      </th>
      <th>
        First Name
      </th>
      <th>
        Last Name
      </th>
      <th>
        Administration
      </th>
      <th>

      </th>
      <th>

      </th>
      <th>

      </th>
    </tr>
    <tr each={users}>
      <td>
        {this.username}
      </td>
      <td>
        {this.password}
      </td>
      <td>
        {this.name_f}
      </td>
      <td>
        {this.name_l}
      </td>
      <td>
        {this.is_admin?'Admin':'User'}
      </td>
      <td>
        <button type="button" onclick={update_user} class="btn btn-default">Update User</button>
      </td>
      <td>
        <button type="button" onclick={delete_user} class="btn btn-danger">Delete User</button>
      </td>
      <td>
        <button type="button" onclick={promote}>Promote User</button>
      </td>
    </tr>
  </table>

  <div id="user_target"></div>
  <div id="user_done" hidden="hidden">
    "Update Successful"
  </div>
  <br><br>

  <table class="table table-bordered table-striped table-hover table-responsive" id="posts-table">
    <tr>
      <th>
        Post ID
      </th>
      <th>
        Post Title
      </th>
      <th>

      </th>
      <th>

      </th>
    </tr>
    <tr each={posts}>
      <td>
        {this.post_id}
      </td>
      <td>
        {this.post_title}
      </td>
      <td>
        <button type="button" class="btn btn-default" onclick={update_post}>Update</button>
      </td>
      <td>
        <button type="button" class="btn btn-danger" onclick={delete_post}>Delete</button>
      </td>
    </tr>
  </table>

  <div id="post_target"></div>
  <div id="post_done" hidden="hidden">
    "Update Successful"
  </div>
  <br><br>
  <script>
    this.on("before-mount", () => {
      socket.emit('users:View')
      socket.once('view-fin',(data) => {
        if(data.result!==undefined&&data.result==false){
          document.getElementById('display-table').hidden=true;
          riot.route('/home','APG/Blog Home')
        }else {
          this.users=data;
        }
        socket.emit('posts:ViewAll')
        socket.once('fetched',(data) => {
          this.posts=data;
          if (this.posts.result!==undefined&&this.posts.result==false) {
            riot.route('/home',"APG/Blog Home: You don't have permission")
          }else {
          }
          this.update()
        })
      })
      this.update();
    })

    this.on('update',()=>{
    })

    this.updating=false;

    this.updating_user=null;
    this.updating_post=null

    update_post(e){
      document.getElementById('user_done').hidden=true;
      if(this.updating_post!=null)
        this.updating_post.unmount(true);
      this.updating_post=riot.mount('div#post_target','updater',{which:'post',core:e.item,parent:this})[0]
    }

    update_user(e){
      if(this.updating_user!=null)
        this.updating_user.unmount(true);
      this.updating_user=riot.mount('div#user_target','updater',{which:'user',core:e.item,parent:this})[0]
    }

    delete_post(e){
      socket.emit('posts:Delete',e.item)
      socket.once('del-post-fin',(data) => {
        if (data.result==true) {
          socket.emit('posts:ViewAll')
          socket.once('fetched',(data) => {
            this.posts=data;
            this.update()
          })
        }else {
        }
      })
    }
    delete_user(e){
      socket.emit('users:Kill',e.item)
      socket.once('done',()=>{
        socket.emit('users:View')
        socket.once('view-fin',(data) => {
          this.users=data;
          this.update();
        })
      })
    }

    promote(e){
      socket.emit('users:Promote',e.item)
      socket.once('done',()=>{
        socket.emit('users:View')
        socket.once('view-fin',(data) => {
          this.users=data;
          this.update();
        })
      })
    }

  </script>

  <style scoped>
    :scope p {
      color: #000;
    }
  </style>
</admin>
