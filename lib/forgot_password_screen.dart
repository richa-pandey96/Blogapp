import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blog_app/loginpage.dart';
// ignore: unused_import
//import 'package:rider_app/Screens/main_screen.dart';
import 'package:blog_app/global.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailTextEditingcontroller=TextEditingController(); 
  final _formKey=GlobalKey<FormState>();

  void _submit() async{
    firebaseAuth.sendPasswordResetEmail(
      email:emailTextEditingcontroller.text.trim()
      ).then((value){
        Fluttertoast.showToast(msg: "We have sent you an email to recover password, please check email");
      }).onError((error, stackTrace){
        Fluttertoast.showToast(msg: "Error Occured: \n ${error.toString()}");
      });
  }

  @override
  Widget build(BuildContext context) {
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
                  'Forgot Password Screen',
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
                            'Send Reset Password Link',
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
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                
                              ),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));

                                },
                                child: Text(
                                  "Login",
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
    // ignore: empty_statements, dead_code
    );;
  }
}