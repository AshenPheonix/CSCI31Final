
<login>
  <form>
    <fieldset>
      <legend>Log In To APG/Blog </legend>
      <div class="form-group">
        <label for="username">User Name</label>
        <input type="text" name="username" id="username" value="" placeholder="Username">
      </div>
      <div class="form-group">
        <label for="password">Pass Word</label>
        <input type="password" name="password" id="password" value="" placeholder="Password Please">
      </div>
      <button type="submit" class="btn btn-primary" id="subbut" onclick={submit}>Submit</button>
      <span class="Error-Field" id="errorfield" hidden={!error}> Error in Username or Password </span>
  </fieldset>
</form>

  <script>
  this.error=false;
  this.on("mount", () => {
  })

  submit(e){
    var temp={username:document.getElementById('username').value,password:document.getElementById('password').value}
    if (temp.uname==="" || temp.pw==="") {
      this.error=true;
      document.getElementById('errorfield').innerText='Please fill out the entirety of the form';
    }else {
      this.error=false;
      document.getElementById('subbut').disabled=true;
      socket.emit('users:login',temp)
      socket.once("log-fin", (data) => {
        if (data.success!==undefined && data.success==false) {
          document.getElementById('subbut').disabled=false;
          this.error=true;
          document.getElementById('errorfield').innerText='Username and/or password not found'
          this.update()
        }else {
          riot.vdom[0].update();
          riot.route('/','APG Home');
        }
      })
    }

    this.on("unmount", () => {
    })
  }
  </script>

  <style scoped>
    .Error-Field {
      background-color: red;
      color: white;
    }
    :disabled{

    }
  </style>
</login>
