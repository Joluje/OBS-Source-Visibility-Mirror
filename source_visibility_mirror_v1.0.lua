local obs = obslua
local sceneItem = nil
local source_name = ''
local sceneName = ''
local triggerSource = nil
local triggerSourceName = ''
local triggerSourceScene = ''

local function findSceneItem()
    local src = obs.obs_get_source_by_name(sceneName)
    if src then
        local scene = obs.obs_scene_from_source(src)
        obs.obs_source_release(src)
        if scene then
            sceneItem = obs.obs_scene_find_source(scene, source_name)
            return true
        end
    end
end

local function findTriggerSceneItem()
    local src = obs.obs_get_source_by_name(triggerSourceScene)
    if src then
        local scene = obs.obs_scene_from_source(src)
        obs.obs_source_release(src)
        if scene then
            triggerSource = obs.obs_scene_find_source(scene, triggerSourceName)
            return true
        end
    end
end

function script_description()
  return "Bei Trigger-Source die Quelle auswaehlen dessen Sichtbarkeit auf die bei Display-Source ausgewaehlte Quelle uebertragen werden soll. Bei Trigger-Scene und Display-Scene die Namen der Szenen eintragen in der sich die entsprechende Quelle befindet."
end

function script_update(settings) 
    triggerSourceName = obs.obs_data_get_string(settings, 'trsource')
    source_name = obs.obs_data_get_string(settings, 'source')
    sceneName = obs.obs_data_get_string(settings, 'scene')
    triggerSourceScene = obs.obs_data_get_string(settings, 'trscene')
    print('triggerSourceName')
    print(triggerSourceName)
    print('source name')
    print(source_name)
    print("script_update")
end

function script_tick()
    findSceneItem()
    findTriggerSceneItem()   
	obs.obs_sceneitem_set_visible(sceneItem, obs.obs_sceneitem_visible(triggerSource))    
end

function script_properties()
local props = obs.obs_properties_create()
    
	local trp =
        obs.obs_properties_add_list(
            props,
            'trsource',
            'Trigger-Source',
            obs.OBS_COMBO_TYPE_EDITABLE,
            obs.OBS_COMBO_FORMAT_STRING)
    local trsources = obs.obs_enum_sources()
    if trsources then
        for _, source in ipairs(trsources) do
            local name = obs.obs_source_get_name(source)
            obs.obs_property_list_add_string(trp, name, name)
        end
    end
    obs.source_list_release(trsources)

     obs.obs_properties_add_text(
        props,
        'trscene',
        'Trigger-Scene',
        obs.OBS_TEXT_DEFAULT)

    local p =
        obs.obs_properties_add_list(
            props,
            'source',
            'Display-Source',
            obs.OBS_COMBO_TYPE_EDITABLE,
            obs.OBS_COMBO_FORMAT_STRING)
    local sources = obs.obs_enum_sources()
    if sources then
        for _, source in ipairs(sources) do
            local name = obs.obs_source_get_name(source)
            obs.obs_property_list_add_string(p, name, name)
        end
    end
    obs.source_list_release(sources)


    obs.obs_properties_add_text(
        props,
        'scene',
        'Display-Scene',
        obs.OBS_TEXT_DEFAULT)
    


    return props 
end




   