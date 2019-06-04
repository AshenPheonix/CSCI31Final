/*
  --Author:Brandon Porter
  --CSCI 31 Final
*/
var project=require('express.io')();
var express=require('express.io');
var db=require(__dirname+'/server/db.js');
var sha1 = require('sha-1');
var riot = require('riot');
project.http().io();

//uses to allow for ease of migration
project.use(express.cookieParser())
project.use(express.session({secret:'dolphin'}))
project.use('/css',express.static(__dirname+'/client/css'))
project.use('/js',express.static(__dirname+'/client/js'))

//router locations for db work, users
project.io.route('users',{
  login:(req) => {
    if(req.data.uname!==undefined || req.data.username===undefined)
      req.data.username==req.data.uname
    if(req.data.password!==undefined)
      req.data.password=sha1(req.data.password)
    else if(req.data.pw!==undefined)
      req.data.password=sha1(req.data.pw)
    db.LoginUser(req.data,(res)=>{
      if(res.error!=undefined&&res.error===true){
        req.io.emit('log-fin',{success:false})
      }else {
        req.session.user=res;
        req.session.logged=true;
        req.session.save(() => {
          req.io.emit('log-fin',req.session)
        })
      }
    },(error)=>{console.log(error);}
    )
  },
  Update:(req) => {
    if(req.session.user.is_admin==0&&req.data.username!=req.session.user.username){
      req.io.emit('finished',{result:false,reason:'No Permission'})
      return;
    }
    var sender ={
      username:req.data.updates.username,
      name_f:req.data.updates.name_f,
      name_l:req.data.updates.name_l,
      password:req.data.updates.password
    };
    if(sender.username===undefined){
      delete sender.username;
    }
    if(sender.name_f===undefined){
      delete sender.name_f;
    }
    if(sender.name_l===undefined){
      delete sender.name_l
    }
    if (sender.password==undefined) {
      delete sender.password
    }
    if (sender.hasOwnProperty('username')) {
      db.CheckUser(sender,(test)=>{
        if (test) {
          req.io.emit('finished', {result:false,reason:'Duplicate UserName'})
          return;
        } else {
          db.EditUser(req.data.username,sender,(result)=>{
            req.io.emit('finished',{result:true})
          },(error)=>{
            console.log('edit error::',error);
          })
        }
      },(err)=>{
        console.log('error::',err)
      })
    }else {
      db.EditUser(req.data.username,temp,
      (result)=>{
        req.io.emit('finished',{result:true})
      },(err)=>{
        console.log('error::',err)
      })
    }
  },
  Create:(req) => {
    if(req.data.password!==undefined)
      req.data.password=sha1(req.data.password)
    db.CheckUser(req.data.username,(returned)=>{
      if(returned==true){
        req.io.emit('cre-fin',{result:false,reason:'User Already Exists'})
      }else {
        db.AddUser(req.data,(result)=>{
          req.io.emit('cre-fin',{result:true})
        },(err)=>{
          req.io.emit('cre-fin',{result:false,reason:'User Already Exists',error:err})
        });

      }
    },(error)=>{
      console.log('error in create::',error)})
  },

  View:(req) => {
    db.CheckAdmin(req.session.user,(back)=>{
      if(back==false)
        req.io.emit('view-fin',{result:false,reason:'No Permission'})
      else {
        db.ViewUsers(req.session.user,(users)=>{
          req.io.emit('view-fin', users)
        },(err)=>{
          console.log('error',err)
        }
      )
      }
    }),(error)=>{console.log('errored ::',error);req.io.emit('view-fin',error)}
  },
  Logout:(request) => {
    request.session.logged=false;
    request.session.user=null;
    request.session.save(()=>{
      request.io.emit('logout-fin')
    })
  },
  Kill:(request) => {
    db.KillUser(request.session.user,request.data,()=>{
      request.io.emit('done')})
  },
  Promote:(req)=>{
    db.PromoteUser(req.data.username,(ret)=>{
      req.io.emit('done',ret)
    },(err)=>{
    })
  }
})


//db work, post variants
project.io.route('posts',{
  ViewAll:(req) => {
    db.ViewPosts((result)=> {
      req.io.emit('fetched',result)
    },(err)=>{
      req.io.emit('fetched',err)
    });
  },
  ViewOne:(req) => {
    db.ViewPost(req.data.pageID,(result)=>{
      req.io.emit('fetched-one',result)
    },(err)=>{
      console.log('error',err)
    })
  },
  Create:(req) => {
    if(req.session.user.username!==undefined){
      db.AddPost(req.data,req.session.user.username,(result)=>{
        req.io.emit('post-cre-fin',{result:true,value:'entered'})
      },(err)=> {
        req.io.emit('post-cre-fin',{result:false,reason:err})
      })
    }else
      req.io.emit('post-cre-fin',{result:false})
  },
  Delete:(req) => {
    if (req.session.user.is_admin==1) {
      db.KillPost(req.data.post_id);
      req.io.emit('del-post-fin',{result:true})
    }else {
      req.io.emit('del-post-fin',{result:false,reason:'No Permission'})
    }
  },
  Update:(req) => {

    db.ViewPost(req.data.post_id,(toEdit)=>{

      if(toEdit.username==req.session.username || req.session.user.is_admin!=0){

        db.EditPost(req.data.post_id,req.data.updates,(results)=>{
          req.io.emit('finished',{result:true})
        },(error)=>{
        })
      }else {

        req.io.emit('finished',{result:false,reason:'No Permission'})
      }
    })
  }
})

//generalized login check
project.io.route('login',{
  check:(req) => {
    req.io.emit('login-check-val',req.session);
  }
})

project.io.route('test',()=>{
  console.log("caught me");

})

//send files
project.get('*',(req,res)=>{
  req.session.loginDate=new Date().toString()
  res.sendfile(__dirname+'/client/index.html')
})
project.post('*',(req,res)=>{
  req.session.loginDate=new Date().toString()
  res.sendfile(__dirname+'/client/index.html')
})

//start listening.
project.listen(process.env.PORT,()=>{
  console.log("started ::",process.env.PORT);
})
