import 'package:blog_app/views/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:rider_app/Screens/main_screen.dart';
import 'package:blog_app/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final nameTextEditingcontroller=TextEditingController();
  final emailTextEditingcontroller=TextEditingController();
  final phoneTextEditingcontroller=TextEditingController();
  final addressTextEditingcontroller=TextEditingController();
  final passwordTextEditingcontroller=TextEditingController();
  final confirmTextEditingcontroller=TextEditingController();

  // ignore: unused_field
  bool _passwordVisible=false;

  // ignore: unused_field
  final _formKey=GlobalKey<FormState>();

  void _submit() async {
    if(_formKey.currentState!.validate()){
      await firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingcontroller.text.trim(), 
      password: passwordTextEditingcontroller.text.trim()
      ).then((auth) async{
        currentUser=auth.user;

        if(currentUser!=null){
          Map userMap={
            "id":currentUser!.uid,
            "name":nameTextEditingcontroller.text.trim(),
            "email":emailTextEditingcontroller.text.trim(),
            "address":addressTextEditingcontroller.text.trim(),
            "phone":phoneTextEditingcontroller.text.trim(),
          };

          DatabaseReference userRef=FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg:"Successfully Registered");
        Navigator.push(context,MaterialPageRoute(builder: (c)=> MyHomePage()));

      }).catchError((errorMessage){
        Fluttertoast.showToast(msg:"Error occured: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg:"Not all fiels are valid");
      }
    }
  

  @override
  Widget build(BuildContext context){
    bool darkTheme=MediaQuery.of(context).platformBrightness==Brightness.dark;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body:ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                Image.asset(darkTheme ? 'images/80575.jpg':'images/80575'),
                SizedBox(height: 20,),

                Text(
                  'Register',
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade400: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding:const EdgeInsets.fromLTRB(15, 20, 15, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person,color:darkTheme?Colors.amber.shade400:Colors.grey,),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text==null || text.isEmpty){
                                return 'Name can\'t be empty';
                              }
                              if(text.length<2){
                                return 'Please enter a valid name';
                              }
                              if(text.length>49){
                                return 'Name can\'t be more than 50';
                              }
                              return null;
                            },
                            onChanged: (text) =>setState(() {
                              nameTextEditingcontroller.text= text;
                            }),
                          ),
                          SizedBox(height: 20,),

                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 183, 62, 62),
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person,color:darkTheme?Colors.amber.shade400:Colors.grey,),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text==null || text.isEmpty){
                                return 'Email can\'t be empty';
                              }
                              if(EmailValidator.validate(text)==true){
                                return null;
                              }
                              if(text.length<2){
                                return 'Please enter a valid email';
                              }
                              if(text.length>99){
                                return 'Email can\'t be more than 100';
                              }
                              return null;
                            },
                            onChanged: (text) =>setState(() {
                              emailTextEditingcontroller.text= text;
                            }),
                          ),
                          SizedBox(height: 20,),
                          IntlPhoneField(
                            showCountryFlag: false,
                            dropdownIcon: Icon(
                              Icons.arrow_drop_down,
                              color: darkTheme ? Colors.amber.shade400 :Colors.grey,
                            ),
                            decoration: InputDecoration(
                              hintText: "Phone",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 183, 62, 62),
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                    
                            ),
                            //initialCountryCode: 'BD',
                            onChanged: (text)=>setState(() {
                              phoneTextEditingcontroller.text=text.completeNumber;
                            }),
                          ),
                          TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            decoration: InputDecoration(
                              hintText: "Address",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 183, 62, 62),
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person,color:darkTheme?Colors.amber.shade400:Colors.grey,),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text==null || text.isEmpty){
                                return 'Address can\'t be empty';
                              }
                              
                              if(text.length<2){
                                return 'Please enter a valid address';
                              }
                              if(text.length>99){
                                return 'Address can\'t be more than 100';
                              }
                              return null;
                            },
                            onChanged: (text) =>setState(() {
                              addressTextEditingcontroller.text= text;
                            }),
                          ),
                          SizedBox(height: 20,),

                          TextFormField(
                            obscureText: !_passwordVisible,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 183, 62, 62),
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person,color:darkTheme?Colors.amber.shade400:Colors.grey,),
                              suffixIcon: IconButton(
                                icon: Icon(
                                _passwordVisible ? Icons.visibility:Icons.visibility_off,
                                color: darkTheme ? Colors.amber.shade400: Colors.grey,
                              ),
                              onPressed: (){
                                setState(() {
                                  _passwordVisible=!_passwordVisible;
                                });
                              },
                              )
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text==null || text.isEmpty){
                                return 'password can\'t be empty';
                              }
                              if(EmailValidator.validate(text)==true){
                                return null;
                              }
                              if(text.length<6){
                                return 'Please enter a valid password';
                              }
                              if(text.length>49){
                                return 'password can\'t be more than 50';
                              }
                              return null;
                            },
                            onChanged: (text) =>setState(() {
                              passwordTextEditingcontroller.text= text;
                            }),
                          ),
                           SizedBox(height: 20,),

                          TextFormField(
                            obscureText: !_passwordVisible,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 183, 62, 62),
                              ),
                              filled: true,
                              fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              prefixIcon: Icon(Icons.person,color:darkTheme?Colors.amber.shade400:Colors.grey,),
                              suffixIcon: IconButton(
                                icon: Icon(
                                _passwordVisible ? Icons.visibility:Icons.visibility_off,
                                color: darkTheme ? Colors.amber.shade400: Colors.grey,
                              ),
                              onPressed: (){
                                setState(() {
                                  _passwordVisible=!_passwordVisible;
                                });
                              },
                              )
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (text){
                              if(text==null || text.isEmpty){
                                return 'Confirm password can\'t be empty';
                              }
                              if(EmailValidator.validate(text)==true){
                                return null;
                              }
                              if(text.length<6){
                                return 'Please enter a valid password';
                              }
                              if(text.length>49){
                                return 'password can\'t be more than 50';
                              }
                              return null;
                            },
                            onChanged: (text) =>setState(() {
                              confirmTextEditingcontroller.text= text;
                            }),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: darkTheme?Colors.black:Colors.white, 
                              backgroundColor: darkTheme ? Colors.amber.shade400:Colors.blue,
                              elevation:0,
                              shape:RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              minimumSize: Size(double.infinity,50),
                            ),
                          onPressed: (){
                            _submit();
                          }, 
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          ),
                          SizedBox(height:20,),
                          GestureDetector(
                            onTap: () {},
                            child:Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: darkTheme ? Colors.amber.shade400: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height:20 ,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Have an account ?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                
                              ),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Text(
                                  "Sign In",
                                  style:TextStyle(
                                    fontSize: 15,
                                    color: darkTheme ?Colors.amber.shade400:Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      ),
                    ],
                  ),
                  ),
              ],
            )
          ],
        )
      ),
    );
  }
}