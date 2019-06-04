
<join>
  <form >
    <form>
      <fieldset>
        <legend>Join APG/Blog </legend>
        <div class="form-group">
          <label for="username">User Name</label>
          <input type="text" name="username" id="username" value="" placeholder="Username">
        </div>
        <div class="form-group">
          <label for="f_name">First Name</label>
          <input type="text" name="f_name" id='firstname' value="" placeholder="First Name">
        </div>
        <div class="form-group">
          <label for="l_name">Last Name</label>
          <input type="text" name="l_name" id='lastname' value="" placeholder="Last Name">
        </div>
        <div class="form-group">
          <label for="password">Pass Word</label>
          <input type="password" name="password" id="password" value="" placeholder="Password Please">
        </div>
        <button type="submit" class="btn btn-primary" id="subbut" onclick={submit}>Submit</button>
        <span class="Error-Field" id="errorfield" hidden={!error}> Error in Username or Password </span>
    </fieldset>
  </form>
  </form>
  <script>
    this.error=false;
    this.on("mount", () => {

    })

    this.on("unmount", () => {
    })

    submit(e){
      var temp={
        username:document.getElementById('username').value,
        name_f:document.getElementById('firstname').value,
        name_l:document.getElementById('lastname').value,
        password:document.getElementById('password').value
      }
      if(temp.username==""||temp.f_name==""||temp.l_name==""||temp.password==""){
        this.error=true;
        document.getElementById('errorfield').innerText='Please fill out the entirety of the form';
        this.update();
      }else {
        this.error=false;
        document.getElementById('subbut').disabled=true;
        socket.emit('users:Create',temp)
        socket.once("cre-fin", (data) => {
          if (data.result!==undefined && data.result==false) {
            document.getElementById('subbut').disabled=false;
            this.error=true;
            document.getElementById('errorfield').innerText=data.reason;
            this.update();
          }else {
            this.error=true;
            document.getElementById('errorfield').innerText='Thank you, Logging you in';
            socket.emit('users:login',temp)
            socket.once('log-fin',()=>{
              riot.update();
              riot.route('/home','APG/Blog Home')
            })
          }
        })
      }
    }
  </script>

  <style scoped>
  .Error-Field {
    background-color: red;
    color: white;
  }
  </style>
</join>
