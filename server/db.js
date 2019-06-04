var chassis=require('mysql-chassis');
var sql=require('friendly-sql').parse('server/sqls/main.sql');
var sha=require('sha-1');
var db=new chassis({
  database:'blog',
  user:'root',
  password:''
});
module.exports = {

  CheckAdmin:(user,next,err)=>{
    db.select(sql('Get User'),{ufn:user.name_f,uln:user.name_l,uname:user.username})
    .then((result) => {

      next(result[0].is_admin==1)
    }).catch((err) => {
      next("Error Happened ::" + err.sql)
    });
  },
  LoginUser:(user,next,err)=>{

    db.select('select username,name_f,name_l,is_admin from users where password=:password and username=:uname',{uname:user.username,password:user.password}).then((result) => {
      if (result.length<1) {
        next({error:true});
      } else {
        next(result[0]);
      }
    }).catch((err) => {
      console.log('failed :: ',err)
      err( {error:true,sql:err.sql})
    })
  },
  ViewPosts:(next,err) => {
    db.select(sql('View Posts')).then((result) => {
      next(result)
    }).catch((err) => {
      err({error:err.err,sql:err.sql})
    })
  },
  ViewPost:(which,next,err) => {
    db.select(sql('View Post'),{pid:which}).then((result) => {
      next(result[0])
    }).catch((err) => {
      err({error:err.err,sql:err.sql})
    })
  },
  EditPost:(pid,data,next,err) => {
    db.update('blog_posts',data,{post_id:pid}).then((res) => {
      next(res)
    }).catch((error) => {err(error)})
  },
  EditUser:(uid,data,next,err) => {
    db.update('users',data,{username:uid}).then((res) => {
      next(res)
    }).catch((err) => {
      err(err)
    })
  },
  ViewUsers:(uid,next,err) => {
    db.select(sql('Admin User View')).then((res) => {
      next(res)
    }).catch((err) => {
      err(err)
    })
  },
  AddUser:(data,next,error) => {
    if(data.hasOwnProperty('username')&&data.hasOwnProperty('password')&&data.hasOwnProperty('name_f')&&data.hasOwnProperty('name_l')&&!data.hasOwnProperty('isAdmin')){
      db.insert('users',data).then((res) => {
        next({result:true,sql:res.sql})
      }).catch((err) => {
        error({result:false,reason:err.sql})
      })
    }else {
      error({result:false,reason:'Not Sent'})
    }
  },
  AddPost:(data,user,next,err)=>{
    if(data.hasOwnProperty('post_title')&&data.hasOwnProperty('post_body')){
      data.username=user;
      db.insert('blog_posts',data).then((res) => {
        next(res)
      }).catch((err) => {
        err(err)
      })
    }
  },
  KillPost:(pid,next,err) => {
    db.delete('blog_posts',{post_id:pid}).then((result) => {
      next(result)
    }).catch((err) => {
      err(err)
    })
  },
  KillUser:(user,target,next,err) => {
      if(!target.hasOwnProperty('username') || user.is_admin===0){
        err(false)
      }else {
        db.delete('users',{username:target.username})
        next(true)
      }
  },
  CheckUser:(user,next,err) => {
    var sent={username:user}
    db.select('select count(username) as count from users where username = :username',sent).then((result) => {
      if (result[0].count>0) {
        next(true)
      }else{
        next(false)}
    }).catch((error) => {
      err(error)
    })
  },
  CheckCredentials:(user,next,err) => {

    db.select('select count(username) as count where from users username = :username and password = :password',{username:user.username,password:user.password}).then((result) => {
      next((result[0].count==1))
    }).catch((error) => {
      err(error)
    })
  },
  PromoteUser:(user,next,err)=>{
    db.update('users',{is_admin:1},{username:user}).then((result)=>{
      next(result)
    }).catch((error)=>{
      err(error)
    })
  }
};
