import 'package:blog_app/views/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:blog_app/forgot_password_screen.dart';
//import 'package:rider_app/Screens/main_screen.dart';
import 'package:blog_app/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditingcontroller=TextEditingController();
  final passwordTextEditingcontroller=TextEditingController();

  bool _passwordVisible=false;

  final _formKey=GlobalKey<FormState>();

  void _submit() async {
    if(_formKey.currentState!.validate()){
      await firebaseAuth.signInWithEmailAndPassword(
      email: emailTextEditingcontroller.text.trim(), 
      password: passwordTextEditingcontroller.text.trim()
      ).then((auth) async{
        currentUser=auth.user;

        
        await Fluttertoast.showToast(msg:"Successfully Logged In");
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
                  'Login',
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
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          ),
                          SizedBox(height:20,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (c)=>ForgotPasswordScreen()));
                            },
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
                                "Doesn't have an account ?",
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
                                  "Register",
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