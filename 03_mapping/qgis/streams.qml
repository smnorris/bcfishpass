<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" version="3.16.1-Hannover" hasScaleBasedVisibilityFlag="0" minScale="1e+08" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <customproperties/>
  <renderer type="basic">
    <styles>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient &lt; .03" name="Streams, 0-3%" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .03 AND gradient &lt; .05" name="Streams, 3-5%" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .05 AND gradient &lt; .10" name="Streams, 5-10%" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.6" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150')AND gradient >= .10" name="Streams, >=10%" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.4" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient &lt; .03" name="Streams, 0-3%, intermittent" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.66" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .03 AND gradient &lt; .05" name="Streams, 3-5%, intermittent" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .05 AND gradient &lt; .1" name="Streams, 5-10%, intermittent" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="10" layer="bcfishpass.streams" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'ACCESSIBLE'OR &quot;accessibility_model_wct&quot; = 'ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .1" name="Streams, >=10%, intermittent" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="18,155,219,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.5" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient &lt; .03" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .03 AND gradient &lt; .05" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .05 AND gradient &lt; .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.6" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.4" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient &lt; .03" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.6666" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .03 AND gradient &lt; .05" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .05 AND gradient &lt; .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="255,159,133,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.5" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient &lt; .03" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties" type="Map">
                    <Option name="fillColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                    <Option name="outlineColor" type="Map">
                      <Option value="true" name="active" type="bool"/>
                      <Option value="CASE WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#129bdb' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff9f85' WHEN &quot;accessibility_model_steelhead&quot; IN () THEN '#ff6b6b' ELSE '#ff9f85' END" name="expression" type="QString"/>
                      <Option value="3" name="type" type="int"/>
                    </Option>
                  </Option>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .03 AND gradient &lt; .5" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="square" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .05 AND gradient &lt; .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="square" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.6" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; IS NOT 'GA24850150') AND gradient >= .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="square" k="capstyle"/>
              <prop v="5;2" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.4" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="0" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient &lt; .03" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.666" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .03 AND gradient &lt; .05" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="1.2" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient >= .05 AND gradient &lt; .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.7" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
      <style min-zoom="-1" layer="" max-zoom="-1" expression="(&quot;accessibility_model_steelhead&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_salmon&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM' OR &quot;accessibility_model_wct&quot; = 'POTENTIALLY ACCESSIBLE - PSCIS BARRIER DOWNSTREAM') AND (&quot;feature_code&quot; = 'GA24850150') AND gradient > .1" name="" geometry="1" enabled="1">
        <symbols>
          <symbol clip_to_extent="1" name="0" alpha="1" force_rhr="0" type="line">
            <layer locked="0" pass="0" class="SimpleLine" enabled="1">
              <prop v="0" k="align_dash_pattern"/>
              <prop v="round" k="capstyle"/>
              <prop v="2;3.5" k="customdash"/>
              <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
              <prop v="MM" k="customdash_unit"/>
              <prop v="0" k="dash_pattern_offset"/>
              <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
              <prop v="MM" k="dash_pattern_offset_unit"/>
              <prop v="0" k="draw_inside_polygon"/>
              <prop v="round" k="joinstyle"/>
              <prop v="239,69,69,255" k="line_color"/>
              <prop v="solid" k="line_style"/>
              <prop v="0.5" k="line_width"/>
              <prop v="MM" k="line_width_unit"/>
              <prop v="0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0" k="ring_filter"/>
              <prop v="0" k="tweak_dash_pattern_on_corners"/>
              <prop v="1" k="use_custom_dash"/>
              <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </symbols>
      </style>
    </styles>
  </renderer>
  <labeling type="basic">
    <styles/>
  </labeling>
</qgis>
