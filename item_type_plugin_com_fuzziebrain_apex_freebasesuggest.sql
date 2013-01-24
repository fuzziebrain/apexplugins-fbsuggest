set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,2094112144576023));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,101);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/item_type/com_fuzziebrain_apex_freebasesuggest
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'ITEM TYPE'
 ,p_name => 'COM.FUZZIEBRAIN.APEX.FREEBASESUGGEST'
 ,p_display_name => 'Freebase Suggest Text Field'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render_freebase_suggest ('||unistr('\000a')||
'  p_item                in apex_plugin.t_page_item,'||unistr('\000a')||
'  p_plugin              in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_value               in varchar2,'||unistr('\000a')||
'  p_is_readonly         in boolean,'||unistr('\000a')||
'  p_is_printer_friendly in boolean )'||unistr('\000a')||
'  return apex_plugin.t_page_item_render_result'||unistr('\000a')||
'is'||unistr('\000a')||
'  l_apikey           varchar2(50);'||unistr('\000a')||
'  l_name             varchar2(30);'||unistr('\000a')||
'  l_body             varchar2(3276'||
'7);'||unistr('\000a')||
'  l_enable_filter    char(1);'||unistr('\000a')||
'  l_filter           varchar2(100);'||unistr('\000a')||
'  l_lang             varchar2(2);'||unistr('\000a')||
'  l_result           apex_plugin.t_page_item_render_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  if p_is_readonly or p_is_printer_friendly then'||unistr('\000a')||
'    apex_plugin_util.print_hidden_if_readonly ('||unistr('\000a')||
'      p_item_name           => p_item.name,'||unistr('\000a')||
'      p_value               => p_value,'||unistr('\000a')||
'      p_is_readonly         => p_is_readonly,'||unistr('\000a')||
'   '||
'   p_is_printer_friendly => p_is_printer_friendly );'||unistr('\000a')||
'    apex_plugin_util.print_display_only ('||unistr('\000a')||
'      p_item_name        => p_item.name,'||unistr('\000a')||
'      p_display_value    => p_value,'||unistr('\000a')||
'      p_show_line_breaks => false,'||unistr('\000a')||
'      p_escape           => true,'||unistr('\000a')||
'      p_attributes       => p_item.element_attributes );'||unistr('\000a')||
'  else'||unistr('\000a')||
'    l_name := apex_plugin.get_input_name_for_page_item(false);'||unistr('\000a')||
'    -- Set API Key'||unistr('\000a')||
'    l_apikey'||
' := p_plugin.attribute_01;'||unistr('\000a')||
'    -- Set filter(s)'||unistr('\000a')||
'    l_enable_filter := p_item.attribute_01;'||unistr('\000a')||
'    l_filter := p_item.attribute_02;'||unistr('\000a')||
'    -- Set language (default: en)'||unistr('\000a')||
'    l_lang := nvl(p_item.attribute_03, ''en'');'||unistr('\000a')||
''||unistr('\000a')||
'    /** '||unistr('\000a')||
'    -- Add required libaries for Freebase Suggest. For self-hosting of these '||unistr('\000a')||
'    -- resources, download the Javascript and CSS files, and then add them to'||unistr('\000a')||
'    -- the plugin. Update'||
' the p_directory enteries accordingly.'||unistr('\000a')||
'    */'||unistr('\000a')||
'    apex_javascript.add_library('||unistr('\000a')||
'      p_name                  => ''suggest'','||unistr('\000a')||
'      p_directory             => ''https://www.gstatic.com/freebase/suggest/4_0/'','||unistr('\000a')||
'      p_check_to_add_minified => true);'||unistr('\000a')||
''||unistr('\000a')||
'    apex_css.add_file('||unistr('\000a')||
'      p_name                  => ''suggest'','||unistr('\000a')||
'      p_directory             => ''https://www.gstatic.com/freebase/suggest/4_0/'');'||unistr('\000a')||
''||unistr('\000a')||
'   '||
' -- Load the JS library responsible for initializing the page_item.'||unistr('\000a')||
'    apex_javascript.add_library('||unistr('\000a')||
'      p_name                  => ''apex.freebase.suggest.'','||unistr('\000a')||
'      p_directory             => p_plugin.file_prefix,'||unistr('\000a')||
'      p_version               => ''0.1.0'','||unistr('\000a')||
'      p_check_to_add_minified => true);'||unistr('\000a')||
''||unistr('\000a')||
'    -- Attach the appropriate listener based on plugin component settings.'||unistr('\000a')||
'    if l_enable_filter = ''Y'||
''' then'||unistr('\000a')||
'      apex_javascript.add_onload_code('||unistr('\000a')||
'        p_code    => ''attachFilteredListener('' || p_item.name || '',"'' '||unistr('\000a')||
'                       || l_apikey || ''","'' || l_lang || ''","'' '||unistr('\000a')||
'                       || l_filter || ''");'');'||unistr('\000a')||
'    else'||unistr('\000a')||
'      apex_javascript.add_onload_code('||unistr('\000a')||
'        p_code    => ''attachListener('' || p_item.name || '', "'' '||unistr('\000a')||
'                       || l_apikey || ''","'' || l_lang || ''");'||
''');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    -- Create the necessary HTML code for the page_item.'||unistr('\000a')||
'    l_body := ''<input type="text" name="'' || l_name || ''" '''||unistr('\000a')||
'                || ''id="'' || p_item.name || ''" '''||unistr('\000a')||
'                || ''value="'' || sys.htf.escape_sc(p_value) || ''" '' '||unistr('\000a')||
'                || ''size="'' || p_item.element_width || ''" '' '||unistr('\000a')||
'                || ''maxlength="'' || p_item.element_max_length || ''" '';'||unistr('\000a')||
''||unistr('\000a')||
'    if p_item.el'||
'ement_attributes is not null then'||unistr('\000a')||
'      l_body := l_body || p_item.element_attributes || '' '';'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_body := l_body || ''/>'';'||unistr('\000a')||
'    end if;'||unistr('\000a')||
''||unistr('\000a')||
'    sys.htp.prn(l_body);'||unistr('\000a')||
''||unistr('\000a')||
'    l_result.is_navigable := true;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end render_freebase_suggest;'
 ,p_render_function => 'render_freebase_suggest'
 ,p_standard_attributes => 'VISIBLE:SESSION_STATE:READONLY:SOURCE:ELEMENT:WIDTH:ENCRYPT'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '0.1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2233519504593343 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'APPLICATION'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'API Key'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_display_length => 50
 ,p_max_length => 50
 ,p_is_translatable => false
 ,p_help_text => 'This is an application setting for specifying your API key. Yes, apparently you need <a href="http://wiki.freebase.com/wiki/API#API_Keys" target="_blank">one</a>.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2232216596458009 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Enable filters?'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'N'
 ,p_is_translatable => false
 ,p_help_text => 'Pick yes if you wish to specify a <a href="http://wiki.freebase.com/wiki/Freebase_Suggest#Constraining_suggestions_using_a_filter" target="_blank">filter</a>. Users will still be able to narrow their search results by specifying the filters in the text field.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2232705813462982 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Filter'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_default_value => '(all type:/film/director)'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 2232216596458009 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => '<a href="http://wiki.freebase.com/wiki/ApiSearch#filter" target="_blank">Filters</a> are an important concept in reducing the results to fit the context of the data that is being captured. For more ideas in constructing filters, please check out the <a href="http://wiki.freebase.com/wiki/Search_Cookbook" target="_blank">Search Cookbook</a>. The <a href="http://schemas.freebaseapps.com" target="_blank">Schema Browser</a> is also a good place to start. Browse through the different domain types that can be used in filters.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Language'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'en'
 ,p_is_translatable => false
 ,p_help_text => 'There are a total of <strong>18</strong> languages to choose from to further restrict your search. The default language is <em>English</em>.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2258110094158800 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'English'
 ,p_return_value => 'en'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2258507722159825 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Spanish'
 ,p_return_value => 'es'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2258905781160770 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'French'
 ,p_return_value => 'fr'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2259304272161407 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'German'
 ,p_return_value => 'de'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2259702331162362 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Italian'
 ,p_return_value => 'it'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2260130785164308 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 60
 ,p_display_value => 'Portuguese'
 ,p_return_value => 'pt'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2260529276165069 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 70
 ,p_display_value => 'Chinese'
 ,p_return_value => 'zh'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2260927551165890 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 80
 ,p_display_value => 'Japanese'
 ,p_return_value => 'jp'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2261326041166563 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 90
 ,p_display_value => 'Korean'
 ,p_return_value => 'ko'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2261724531167252 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 100
 ,p_display_value => 'Russian'
 ,p_return_value => 'ru'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2262122590168172 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 110
 ,p_display_value => 'Swedish'
 ,p_return_value => 'sv'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2262520865168924 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 120
 ,p_display_value => 'Finnish'
 ,p_return_value => 'fi'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2262919140169791 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 130
 ,p_display_value => 'Danish'
 ,p_return_value => 'da'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2263316983170789 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 140
 ,p_display_value => 'Dutch'
 ,p_return_value => 'nl'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2264009004174417 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 150
 ,p_display_value => 'Greek'
 ,p_return_value => 'el'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2264406632175597 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 160
 ,p_display_value => 'Romanian'
 ,p_return_value => 'ro'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2264804691176408 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 170
 ,p_display_value => 'Turkish'
 ,p_return_value => 'tr'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 2265201240178093 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 2257412251157761 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 180
 ,p_display_value => 'Hungarian'
 ,p_return_value => 'hu'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E206174746163684C697374656E657228656C5F69642C6170696B65792C6C616E67297B2428656C5F6964292E73756767657374287B226B6579223A6170696B65792C226C616E67223A6C616E677D293B7D0D0A66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(2) := '61747461636846696C74657265644C697374656E657228656C5F69642C6170696B65792C6C616E672C66696C7465725F737472696E67297B2428656C5F6964292E73756767657374287B226B6579223A6170696B65792C226C616E67223A6C616E672C22';
wwv_flow_api.g_varchar2_table(3) := '66696C746572223A66696C7465725F737472696E677D293B7D0D0A66756E6374696F6E2061747461636848616E646C657228656C5F6964297B2428656C5F6964292E62696E64282266622D73656C656374222C66756E6374696F6E28652C64617461297B';
wwv_flow_api.g_varchar2_table(4) := '616C65727428646174612E6E616D652B222C20222B646174612E6964293B7D293B7D';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 2267205472462320 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 9571139552255070483 + wwv_flow_api.g_id_offset
 ,p_file_name => 'apex.freebase.suggest.0.1.0.min.js'
 ,p_mime_type => 'text/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
