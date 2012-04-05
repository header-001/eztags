{def $parent_tag_id = 0}
{if is_set( $tag )}
    {set $parent_tag_id = $tag.id}
{/if}

{def $children_count = fetch( tags, list_count, hash( parent_tag_id, $parent_tag_id ) )}

<div class="context-block">
    <div class="box-header">
        <div class="button-left">
            <h2 class="context-title">
                {if is_set($tag)}<a href={$tag.depth|gt(1)|choose( '/tags/dashboard'|ezurl, concat( '/tags/id/', $tag.parent.id )|ezurl )} title="{'Up one level.'|i18n(  'extension/eztags/tags/view'  )}"><img src={'up-16x16-grey.png'|ezimage} alt="{'Up one level.'|i18n( 'extension/eztags/tags/view' )}" title="{'Up one level.'|i18n( 'extension/eztags/tags/view' )}" /></a>&nbsp;{/if}{'Children tags (%children_count)'|i18n( 'extension/eztags/tags/view',, hash( '%children_count', $children_count ) )}
            </h2>
        </div>
        <div class="button-right button-header"></div>
        <div class="float-break"></div>
    </div>

    <div class="box-content">
        {def $locales = fetch( 'content', 'translation_list' )}

        <div id="action-controls-container">
            <div id="action-controls"></div>
            <div id="tpg"></div>
        </div>
        <div id="eztags-tag-children-table"></div>
        <div id="bpg"></div>

        {def $yui2_base_path = ezini( 'eZJSCore', 'LocalScriptBasePath', 'ezjscore.ini' )}
        {set $yui2_base_path = concat( '/extension/ezjscore/design/standard/', $yui2_base_path['yui2'] )}
        {def $has_add_access = fetch( user, has_access_to, hash( module, tags, function, add ) )}

        <script type="text/javascript">
            var languages = {ldelim}{*
                *}{foreach $locales as $language}{*
                    *}'{$language.locale_code|wash(javascript)}': '{$language.intl_language_name|wash(javascript)}'{*
                    *}{delimiter}, {/delimiter}{*
                *}{/foreach}{*
            *}{rdelim};

            var createGroups = [{*
                *}'{"Translation"|i18n( "extension/eztags/tags/view" )|wash(javascript)}'{*
            *}];

            var createOptions = [{*
                *}{foreach $locales as $language}{*
                    *}{ldelim}'text': '{$language.intl_language_name|wash(javascript)}', 'value': '{$language.locale_code|wash(javascript)}'{rdelim}{*
                    *}{delimiter}, {/delimiter}{*
                *}{/foreach}{*
            *}];

            var icons = {ldelim}{*
                *}{foreach $locales as $locale}{*
                    *}'{$locale.locale_code}': '{$locale.locale_code|flag_icon()}'{*
                    *}{delimiter}, {/delimiter}{*
                *}{/foreach}{*
            *}{rdelim};

            var i18n = {ldelim}{*
                *}'id': '{"ID"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'tag_name': '{"Tag name"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'translations': '{"Tag translations"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'modified': '{"Modified"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'first_page': '&laquo;&nbsp;{"first"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'last_page': '{"last"|i18n( "extension/eztags/tags/view" )|wash(javascript)}&nbsp;&raquo;',{*
                *}'previous_page': '&lsaquo;&nbsp;{"prev"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'next_page': '{"next"|i18n( "extension/eztags/tags/view" )|wash(javascript)}&nbsp;&rsaquo;',{*
                *}'select_visible': '{"Select all visible"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'select_none': '{"Select none"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'select_toggle': '{"Invert selection"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'select': '{"Select"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'add_child': '{"Add tag"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'more_actions': '{"More actions"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'remove_selected': '{"Remove selected tags"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'move_selected': '{"Move selected tags"|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
                *}'no_actions': '{"Use the checkboxes to select one or more tags."|i18n( "extension/eztags/tags/view" )|wash(javascript)}',{*
            *}{rdelim};

            jQuery(document).ready(function($) {ldelim}
                $('#eztags-tag-children-table').eZTagsChildren({ldelim}
                    YUI2BasePath: "{$yui2_base_path}",
                    dataSourceURI: "{concat( '/ezjscore/call/ezjsctagschildren::tagsChildren::', $parent_tag_id, '?' )|ezurl(no)}",
                    rowsPerPage: 10,
                    languages: languages,
                    viewUrl: {'/tags/id/'|ezurl},
                    addUrl: {concat( '/tags/add/', $parent_tag_id )|ezurl},
                    editUrl: {'/tags/edit/'|ezurl},
                    hasAddAccess: {if $has_add_access}true{else}false{/if},
                    icons: icons,
                    i18n: i18n,
                    createOptions: createOptions
                {rdelim});
            {rdelim});
        </script>
    </div>
</div>

{undef}
