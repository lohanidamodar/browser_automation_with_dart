#! /usr/bin/env dcli
import 'package:dcli/dcli.dart';
import 'package:puppeteer/puppeteer.dart';

void main(List<String> args) async {
    print('Welcome to browser automation script.');
    if(args.isEmpty) {
      print('Required one argument, name of the project');
      return;
    }
    var username = ask('username:', defaultValue: "lohanidamodar");
    var password = ask('password:', hidden: true);
    var projName = args.first;
    await _createGithubRepo(username,password,projName);
}

Future<void> _createGithubRepo(String username, String password,String name) async {
  var browser = await puppeteer.launch(headless: false);
  var page = await browser.newPage();
  await page.goto('https://github.com/login',wait: Until.networkIdle);
  var selector = "input[name='login']";
  await page.waitForSelector(selector);
  await page.click(selector);
  await page.type(selector, username);
  selector = "input[name='password']";
  await page.waitForSelector(selector);
  await page.click(selector);
  await page.type(selector, password);
  selector = "input[name='commit']";
  await page.waitForSelector(selector);
  await page.click(selector);

  //redirect page to new repo creation
  await page.goto('https://github.com/new',wait: Until.networkIdle);
  selector = "input[name='repository[name]']";
  await page.waitForSelector(selector);
  await page.click(selector);
  await page.type(selector, name);
  
  //make repo private
  selector = '#repository_visibility_private';
  await page.waitForSelector(selector);
  await page.click(selector);

  //create repo
  selector = 'button.first-in-line:not([disabled])';
  await page.waitForSelector(selector);
  await page.click(selector);

  await browser.close();



}