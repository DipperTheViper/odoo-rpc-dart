import 'dart:io';

import 'package:logger/logger.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

void sessionChanged(OdooSession sessionId) async {
  Logger().i('We got new session ID: ${sessionId.id}');
  // write to persistent storage
}

void loginStateChanged(OdooLoginEvent event) async {
  if (event == OdooLoginEvent.loggedIn) {
    Logger().i('Logged in');
  }
  if (event == OdooLoginEvent.loggedOut) {
    Logger().i('Logged out');
  }
}

void inRequestChanged(bool event) async {
  if (event) Logger().i('Request is executing'); // draw progress indicator
  if (!event) Logger().i('Request is finished'); // hide progress indicator
}

void main() async {
  // Restore session ID from storage and pass it to client constructor.
  // final baseUrl = 'https://id.narvanventures.com';
  final baseUrl = 'https://55618503-17-0-all.runbot210.odoo.com/';
  final client = OdooClient(baseUrl);
  // Subscribe to session changes to store most recent one
  var subscription = client.sessionStream.listen(sessionChanged);
  var loginSubscription = client.loginStream.listen(loginStateChanged);
  var inRequestSubscription = client.inRequestStream.listen(inRequestChanged);

  try {
    // Authenticate to server with db name and credentials
    // final session = await client.authenticate(
    //   'sample',
    //   'mahdikafashkohan@gmail.com',
    //   '123456',
    // );
    final session = await client.authenticate(
      '55618503-17-0-all',
      'admin',
      'admin',
    );
    Logger().i(session);
    Logger().i('Authenticated');

    // Compute image avatar field name depending on server version
    final imageField =
        session.serverVersionInt >= 13 ? 'image_128' : 'image_small';

    // Read our user's fields
    // final uid = session.userId;
    var res = await client.callRPC(
      '/web/dataset/call_kw/res.users/web_read',
      'call',
      '{"id":7,"jsonrpc":"2.0","method":"call","params":{"model":"res.users","method":"web_read","args":[[2]],"kwargs":{"context":{"lang":"en_US","tz":"Europe/Busingen","uid":2,"allowed_company_ids":[1],"bin_size":true,"params":{"id":2,"cids":1,"menu_id":935,"action":324,"model":"res.users","view_type":"form"},"from_my_profile":true},"specification":{"avatar_128":{},"hr_presence_state":{},"employee_ids":{"fields":{}},"employee_id":{"fields":{"display_name":{}}},"request_overtime":{},"last_activity_time":{},"last_activity":{},"last_appraisal_date":{},"last_appraisal_id":{"fields":{}},"hours_last_month_display":{},"display_extra_hours":{},"total_overtime":{},"employee_cars_count":{},"show_leaves":{},"is_absent":{},"hr_icon_display":{},"leave_date_to":{},"allocation_remaining_display":{},"allocation_display":{},"equipment_count":{},"sign_request_count":{},"document_count":{},"image_1920":{},"write_date":{},"name":{},"job_title":{},"can_edit":{},"mobile_phone":{},"work_phone":{},"work_email":{},"work_location_id":{"fields":{"display_name":{}}},"company_id":{"fields":{"display_name":{}},"context":{"user_preference":true}},"employee_parent_id":{"fields":{"display_name":{}}},"coach_id":{"fields":{"display_name":{}}},"notification_type":{},"email":{},"lang":{},"tz":{},"has_access_livechat":{},"livechat_username":{},"livechat_lang_ids":{"fields":{"display_name":{}}},"is_system":{},"tz_offset":{},"share":{},"work_contact_id":{"fields":{}},"signature":{},"property_warehouse_id":{"fields":{"display_name":{}}},"voip_username":{},"onsip_auth_username":{},"voip_secret":{},"how_to_call_on_mobile":{},"should_auto_reject_incoming_calls":{},"should_call_from_another_device":{},"external_device_number":{},"totp_enabled":{},"totp_trusted_device_ids":{"fields":{"name":{},"create_date":{}},"limit":40,"order":""},"api_key_ids":{"fields":{"name":{},"scope":{},"create_date":{}},"limit":40,"order":""},"resume_line_ids":{"fields":{"line_type_id":{"fields":{"display_name":{}}},"name":{},"description":{},"date_start":{},"date_end":{},"display_type":{}},"limit":40,"order":""},"employee_skill_ids":{"fields":{"skill_type_id":{"fields":{"display_name":{}}},"skill_id":{"fields":{"display_name":{}}},"skill_level_id":{"fields":{"display_name":{}}},"level_progress":{}},"limit":40,"order":""},"department_id":{"fields":{"display_name":{}}},"address_id":{"fields":{"display_name":{}},"context":{"show_address":1}},"attendance_manager_id":{"fields":{"display_name":{}}},"leave_manager_id":{"fields":{"display_name":{}}},"expense_manager_id":{"fields":{"display_name":{}}},"timesheet_manager_id":{"fields":{"display_name":{}}},"monday_location_id":{"fields":{"display_name":{}}},"tuesday_location_id":{"fields":{"display_name":{}}},"wednesday_location_id":{"fields":{"display_name":{}}},"thursday_location_id":{"fields":{"display_name":{}}},"friday_location_id":{"fields":{"display_name":{}}},"saturday_location_id":{"fields":{"display_name":{}}},"sunday_location_id":{"fields":{"display_name":{}}},"child_ids":{"fields":{}},"private_street":{},"private_street2":{},"private_city":{},"private_state_id":{"fields":{"display_name":{}}},"private_zip":{},"private_country_id":{"fields":{"display_name":{}}},"private_email":{},"private_phone":{},"private_lang":{},"employee_bank_account_id":{"fields":{"display_name":{}},"context":{"display_partner":true}},"km_home_work":{},"employee_country_id":{"fields":{"display_name":{}}},"identification_id":{},"ssnid":{},"passport_id":{},"gender":{},"disabled":{},"birthday":{},"place_of_birth":{},"country_of_birth":{"fields":{"display_name":{}}},"is_non_resident":{},"marital":{},"spouse_fiscal_status":{},"spouse_fiscal_status_explanation":{},"disabled_spouse_bool":{},"spouse_complete_name":{},"spouse_birthdate":{},"certificate":{},"study_field":{},"study_school":{},"l10n_be_scale_seniority":{},"children":{},"disabled_children_bool":{},"disabled_children_number":{},"dependent_children":{},"other_dependent_people":{},"other_senior_dependent":{},"other_disabled_senior_dependent":{},"other_juniors_dependent":{},"other_disabled_juniors_dependent":{},"emergency_contact":{},"emergency_phone":{},"visa_no":{},"permit_no":{},"visa_expire":{},"employee_type":{},"pin":{},"barcode":{},"display_name":{}}}}}',
    );

    res.then(
      (res) async {
        Logger().i(res);
        //     Logger().i('\nUser info: \n$res');
        //     // compute avatar url if we got reply
        //     if (res.length == 1) {
        //       var unique = res[0]['__last_update'] as String;
        //       unique = unique.replaceAll(RegExp(r'[^0-9]'), '');
        //       final userAvatar =
        //           '$baseUrl/web/image?model=res.user&field=$imageField&id=$uid&unique=$unique';
        //       Logger().i('User Avatar URL: $userAvatar');
        //     }
        //
        //     // Create partner
        //     var partnerId = await client.callKw({
        //       'model': 'res.partner',
        //       'method': 'create',
        //       'args': [
        //         {
        //           'name': 'Stealthy Wood',
        //         },
        //       ],
        //       'kwargs': {},
        //     });
        //     // Update partner by id
        //     res = await client.callKw({
        //       'model': 'res.partner',
        //       'method': 'write',
        //       'args': [
        //         partnerId,
        //         {
        //           'is_company': true,
        //         },
        //       ],
        //       'kwargs': {},
        //     });
        //
        //     // Get list of installed modules
        //     res = await client.callRPC('/web/session/modules', 'call', {});
        //     Logger().i('\nInstalled modules: \n$res');
        //
        //     // Check if loggeed in
        //     Logger().i('\nChecking session while logged in');
        //     res = await client.checkSession();
        //     Logger().i('ok');
        //
        //     // Log out
        //     Logger().i('\nDestroying session');
        //     await client.destroySession();
        //     Logger().i('ok');
      },
    );
  } on OdooException catch (e) {
    // Cleanup on odoo exception
    Logger().i(e);
    await subscription.cancel();
    await loginSubscription.cancel();
    await inRequestSubscription.cancel();
    client.close();
    exit(-1);
  }

  Logger().i('\nChecking session while logged out');
  try {
    var res = await client.checkSession();
    Logger().i(res);
  } on OdooSessionExpiredException {
    Logger().i('Odoo Exception:Session expired');
  }
  await client.inRequestStream.isEmpty;
  await subscription.cancel();
  await loginSubscription.cancel();
  await inRequestSubscription.cancel();
  client.close();
}
