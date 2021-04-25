import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class form extends StatefulWidget {
  @override
  _formState createState() => _formState();
}

class _formState extends State<form> {

  //global keys
  final formkey_name = GlobalKey<FormState>();
  final formkey_phone = GlobalKey<FormState>();
  final formkey_password = GlobalKey<FormState>();
  Widget _user_sign_up_form()
  {
    var size = MediaQuery.of(context).size;
    return Container(
        width: size.width/1.2,
        height: size.height/1.9,
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border.all(
              color: Colors.blueAccent,
              width: 8,
          ),
          borderRadius: BorderRadius.circular(5)
        ),
        child:Column(
            mainAxisSize: MainAxisSize.min,
            children :
            [
              // these containers are the main blocks of building the sign-in sign-up form
              //we can add or delete these if needed in different situations
              //this is just a sample of usage for this layout
              Container(
                padding: EdgeInsets.all(10),
                child: Form(
                    key: formkey_name,
                    child:  TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'enter name',
                      ) , 
                      validator: (value){
                      if (value == null || value.isEmpty)
                      {
                        return "please enter a text";
                      }
                        return null;
                      },
                    ),
                  )
              ),
              Container( 
                padding: EdgeInsets.all(10),
                child:Form(
                    key: formkey_phone,
                    child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'enter phone number'
                    ),
                      validator: (value)
                      {
                        RegExp r= new RegExp('[0-9]{11}');
                        if (value==null || !r.hasMatch(value.toString()))
                          return 'enter a valid phone number';
                        return null;
                      },
                    )
                )
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child:Form(
                    key: formkey_password,
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.security),
                          labelText: 'enter password'
                      ),
                      validator: (value)
                      {
                        RegExp r= new RegExp('^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}');
                        if (value==null || !r.hasMatch(value.toString()))
                          return 'enter a valid password (must be at least 6 characters and contain numbers and letters)';
                        return null;
                      },
                    )
                )
              ),
              Center(
                child: ElevatedButton(
                  child: Text("submit"),
                  onPressed: (){
                      if (formkey_name.currentState!.validate() && formkey_phone.currentState!.validate() && formkey_password.currentState!.validate())
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("proceed")));
                      }
                  },
                ),
              )
            ]
        )
       );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //stack type allows having multiple layers on each other
      body: Stack(
        children: [
          //this is for adding the background image of our sign-in sign-up page
          /*Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/food_pic.jpg"),
                fit: BoxFit.cover,
              )
            )
          ),*/
          Center(
            child: Container(
              child : _user_sign_up_form(),
            ),
          ),
        ]
      ),
    );
  }
}
