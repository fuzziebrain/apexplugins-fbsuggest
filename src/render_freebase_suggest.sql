function render_freebase_suggest (
  p_item                in apex_plugin.t_page_item,
  p_plugin              in apex_plugin.t_plugin,
  p_value               in varchar2,
  p_is_readonly         in boolean,
  p_is_printer_friendly in boolean )
  return apex_plugin.t_page_item_render_result
is
  l_apikey           varchar2(50);
  l_name             varchar2(30);
  l_body             varchar2(32767);
  l_enable_filter    char(1);
  l_filter           varchar2(100);
  l_lang             varchar2(2);
  l_result           apex_plugin.t_page_item_render_result;
begin
  if p_is_readonly or p_is_printer_friendly then
    apex_plugin_util.print_hidden_if_readonly (
      p_item_name           => p_item.name,
      p_value               => p_value,
      p_is_readonly         => p_is_readonly,
      p_is_printer_friendly => p_is_printer_friendly );
    apex_plugin_util.print_display_only (
      p_item_name        => p_item.name,
      p_display_value    => p_value,
      p_show_line_breaks => false,
      p_escape           => true,
      p_attributes       => p_item.element_attributes );
  else
    l_name := apex_plugin.get_input_name_for_page_item(false);
    -- Set API Key
    l_apikey := p_plugin.attribute_01;
    -- Set filter(s)
    l_enable_filter := p_item.attribute_01;
    l_filter := p_item.attribute_02;
    -- Set language (default: en)
    l_lang := nvl(p_item.attribute_03, 'en');

    /** 
    -- Add required libaries for Freebase Suggest. For self-hosting of these 
    -- resources, download the Javascript and CSS files, and then add them to
    -- the plugin. Update the p_directory enteries accordingly.
    */
    apex_javascript.add_library(
      p_name                  => 'suggest',
      p_directory             => 'https://www.gstatic.com/freebase/suggest/4_1/',
      p_check_to_add_minified => true);

    apex_css.add_file(
      p_name                  => 'suggest',
      p_directory             => 'https://www.gstatic.com/freebase/suggest/4_1/');

    -- Load the JS library responsible for initializing the page_item.
    apex_javascript.add_library(
      p_name                  => 'apex.freebase.suggest.',
      p_directory             => p_plugin.file_prefix,
      p_version               => '0.1.0',
      p_check_to_add_minified => true);

    -- Attach the appropriate listener based on plugin component settings.
    if l_enable_filter = 'Y' then
      apex_javascript.add_onload_code(
        p_code    => 'attachFilteredListener(' || p_item.name || ',"' 
                       || l_apikey || '","' || l_lang || '","' 
                       || l_filter || '");');
    else
      apex_javascript.add_onload_code(
        p_code    => 'attachListener(' || p_item.name || ', "' 
                       || l_apikey || '","' || l_lang || '");');
    end if;

    -- Create the necessary HTML code for the page_item.
    l_body := '<input type="text" name="' || l_name || '" '
                || 'id="' || p_item.name || '" '
                || 'value="' || sys.htf.escape_sc(p_value) || '" ' 
                || 'size="' || p_item.element_width || '" ' 
                || 'maxlength="' || p_item.element_max_length || '" ';

    if p_item.element_attributes is not null then
      l_body := l_body || p_item.element_attributes || ' ';
    else
      l_body := l_body || '/>';
    end if;

    sys.htp.prn(l_body);

    l_result.is_navigable := true;
  end if;

  return l_result;
end render_freebase_suggest;