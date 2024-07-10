sidebarNodes={"modules":[{"id":"GameApp","deprecated":false,"group":"","title":"GameApp","sections":[]},{"id":"GameApp.Accounts","deprecated":false,"group":"","title":"GameApp.Accounts","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"create_player/1","deprecated":false,"title":"create_player(attrs \\\\ %{})","anchor":"create_player/1"},{"id":"delete_player/1","deprecated":false,"title":"delete_player(player)","anchor":"delete_player/1"},{"id":"get_player/1","deprecated":false,"title":"get_player(id)","anchor":"get_player/1"},{"id":"get_player!/1","deprecated":false,"title":"get_player!(id)","anchor":"get_player!/1"},{"id":"list_players/0","deprecated":false,"title":"list_players()","anchor":"list_players/0"},{"id":"update_player/2","deprecated":false,"title":"update_player(player, attrs)","anchor":"update_player/2"},{"id":"update_player!/2","deprecated":false,"title":"update_player!(player, attrs)","anchor":"update_player!/2"}],"key":"functions"}]},{"id":"GameApp.Accounts.Player","deprecated":false,"group":"","title":"GameApp.Accounts.Player","sections":[],"nodeGroups":[{"name":"Types","nodes":[{"id":"t/0","deprecated":false,"title":"t()","anchor":"t:t/0"}],"key":"types"},{"name":"Functions","nodes":[{"id":"%GameApp.Accounts.Player{}","deprecated":false,"title":"%GameApp.Accounts.Player{}","anchor":"__struct__/0"},{"id":"create_changeset/1","deprecated":false,"title":"create_changeset(attrs)","anchor":"create_changeset/1"},{"id":"default_score/0","deprecated":false,"title":"default_score()","anchor":"default_score/0"},{"id":"update_changeset/2","deprecated":false,"title":"update_changeset(player, attrs \\\\ %{})","anchor":"update_changeset/2"}],"key":"functions"}]},{"id":"GameApp.External.TextExtractBehaviour","deprecated":false,"group":"","title":"GameApp.External.TextExtractBehaviour","sections":[],"nodeGroups":[{"name":"Callbacks","nodes":[{"id":"extract_text/1","deprecated":false,"title":"extract_text(url)","anchor":"c:extract_text/1"}],"key":"callbacks"}]},{"id":"GameApp.External.TextExtractDevService","deprecated":false,"group":"","title":"GameApp.External.TextExtractDevService","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"extract_text/1","deprecated":false,"title":"extract_text(url)","anchor":"extract_text/1"}],"key":"functions"}]},{"id":"GameApp.External.TextExtractProdService","deprecated":false,"group":"","title":"GameApp.External.TextExtractProdService","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"extract_text/1","deprecated":false,"title":"extract_text(url)","anchor":"extract_text/1"}],"key":"functions"}]},{"id":"GameApp.External.TextExtractService","deprecated":false,"group":"","title":"GameApp.External.TextExtractService","sections":[{"id":"Usage","anchor":"module-usage"}],"nodeGroups":[{"name":"Functions","nodes":[{"id":"extract_text/1","deprecated":false,"title":"extract_text(url)","anchor":"extract_text/1"}],"key":"functions"}]},{"id":"GameApp.LoggerFormatter","deprecated":false,"group":"","title":"GameApp.LoggerFormatter","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"common_metadata/0","deprecated":false,"title":"common_metadata()","anchor":"common_metadata/0"},{"id":"format/4","deprecated":false,"title":"format(level, message, timestamp, metadata)","anchor":"format/4"}],"key":"functions"}]},{"id":"GameApp.Mailer","deprecated":false,"group":"","title":"GameApp.Mailer","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"deliver/2","deprecated":false,"title":"deliver(email, config \\\\ [])","anchor":"deliver/2"},{"id":"deliver!/2","deprecated":false,"title":"deliver!(email, config \\\\ [])","anchor":"deliver!/2"},{"id":"deliver_many/2","deprecated":false,"title":"deliver_many(emails, config \\\\ [])","anchor":"deliver_many/2"}],"key":"functions"}]},{"id":"GameApp.Repo","deprecated":false,"group":"","title":"GameApp.Repo","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"aggregate/3","deprecated":false,"title":"aggregate(queryable, aggregate, opts \\\\ [])","anchor":"aggregate/3"},{"id":"aggregate/4","deprecated":false,"title":"aggregate(queryable, aggregate, field, opts)","anchor":"aggregate/4"},{"id":"all/2","deprecated":false,"title":"all(queryable, opts \\\\ [])","anchor":"all/2"},{"id":"checked_out?/0","deprecated":false,"title":"checked_out?()","anchor":"checked_out?/0"},{"id":"checkout/2","deprecated":false,"title":"checkout(fun, opts \\\\ [])","anchor":"checkout/2"},{"id":"child_spec/1","deprecated":false,"title":"child_spec(opts)","anchor":"child_spec/1"},{"id":"config/0","deprecated":false,"title":"config()","anchor":"config/0"},{"id":"default_options/1","deprecated":false,"title":"default_options(operation)","anchor":"default_options/1"},{"id":"delete/2","deprecated":false,"title":"delete(struct, opts \\\\ [])","anchor":"delete/2"},{"id":"delete!/2","deprecated":false,"title":"delete!(struct, opts \\\\ [])","anchor":"delete!/2"},{"id":"delete_all/2","deprecated":false,"title":"delete_all(queryable, opts \\\\ [])","anchor":"delete_all/2"},{"id":"disconnect_all/2","deprecated":false,"title":"disconnect_all(interval, opts \\\\ [])","anchor":"disconnect_all/2"},{"id":"exists?/2","deprecated":false,"title":"exists?(queryable, opts \\\\ [])","anchor":"exists?/2"},{"id":"explain/3","deprecated":false,"title":"explain(operation, queryable, opts \\\\ [])","anchor":"explain/3"},{"id":"get/3","deprecated":false,"title":"get(queryable, id, opts \\\\ [])","anchor":"get/3"},{"id":"get!/3","deprecated":false,"title":"get!(queryable, id, opts \\\\ [])","anchor":"get!/3"},{"id":"get_by/3","deprecated":false,"title":"get_by(queryable, clauses, opts \\\\ [])","anchor":"get_by/3"},{"id":"get_by!/3","deprecated":false,"title":"get_by!(queryable, clauses, opts \\\\ [])","anchor":"get_by!/3"},{"id":"get_dynamic_repo/0","deprecated":false,"title":"get_dynamic_repo()","anchor":"get_dynamic_repo/0"},{"id":"in_transaction?/0","deprecated":false,"title":"in_transaction?()","anchor":"in_transaction?/0"},{"id":"insert/2","deprecated":false,"title":"insert(struct, opts \\\\ [])","anchor":"insert/2"},{"id":"insert!/2","deprecated":false,"title":"insert!(struct, opts \\\\ [])","anchor":"insert!/2"},{"id":"insert_all/3","deprecated":false,"title":"insert_all(schema_or_source, entries, opts \\\\ [])","anchor":"insert_all/3"},{"id":"insert_or_update/2","deprecated":false,"title":"insert_or_update(changeset, opts \\\\ [])","anchor":"insert_or_update/2"},{"id":"insert_or_update!/2","deprecated":false,"title":"insert_or_update!(changeset, opts \\\\ [])","anchor":"insert_or_update!/2"},{"id":"load/2","deprecated":false,"title":"load(schema_or_types, data)","anchor":"load/2"},{"id":"one/2","deprecated":false,"title":"one(queryable, opts \\\\ [])","anchor":"one/2"},{"id":"one!/2","deprecated":false,"title":"one!(queryable, opts \\\\ [])","anchor":"one!/2"},{"id":"preload/3","deprecated":false,"title":"preload(struct_or_structs_or_nil, preloads, opts \\\\ [])","anchor":"preload/3"},{"id":"prepare_query/3","deprecated":false,"title":"prepare_query(operation, query, opts)","anchor":"prepare_query/3"},{"id":"put_dynamic_repo/1","deprecated":false,"title":"put_dynamic_repo(dynamic)","anchor":"put_dynamic_repo/1"},{"id":"query/3","deprecated":false,"title":"query(sql, params \\\\ [], opts \\\\ [])","anchor":"query/3"},{"id":"query!/3","deprecated":false,"title":"query!(sql, params \\\\ [], opts \\\\ [])","anchor":"query!/3"},{"id":"query_many/3","deprecated":false,"title":"query_many(sql, params \\\\ [], opts \\\\ [])","anchor":"query_many/3"},{"id":"query_many!/3","deprecated":false,"title":"query_many!(sql, params \\\\ [], opts \\\\ [])","anchor":"query_many!/3"},{"id":"reload/2","deprecated":false,"title":"reload(queryable, opts \\\\ [])","anchor":"reload/2"},{"id":"reload!/2","deprecated":false,"title":"reload!(queryable, opts \\\\ [])","anchor":"reload!/2"},{"id":"rollback/1","deprecated":false,"title":"rollback(value)","anchor":"rollback/1"},{"id":"start_link/1","deprecated":false,"title":"start_link(opts \\\\ [])","anchor":"start_link/1"},{"id":"stop/1","deprecated":false,"title":"stop(timeout \\\\ 5000)","anchor":"stop/1"},{"id":"stream/2","deprecated":false,"title":"stream(queryable, opts \\\\ [])","anchor":"stream/2"},{"id":"to_sql/2","deprecated":false,"title":"to_sql(operation, queryable)","anchor":"to_sql/2"},{"id":"transaction/2","deprecated":false,"title":"transaction(fun_or_multi, opts \\\\ [])","anchor":"transaction/2"},{"id":"update/2","deprecated":false,"title":"update(struct, opts \\\\ [])","anchor":"update/2"},{"id":"update!/2","deprecated":false,"title":"update!(struct, opts \\\\ [])","anchor":"update!/2"},{"id":"update_all/3","deprecated":false,"title":"update_all(queryable, updates, opts \\\\ [])","anchor":"update_all/3"}],"key":"functions"}]},{"id":"GameApp.Websites.GetText","deprecated":false,"group":"","title":"GameApp.Websites.GetText","sections":[],"nodeGroups":[{"name":"Types","nodes":[{"id":"t/0","deprecated":false,"title":"t()","anchor":"t:t/0"}],"key":"types"},{"name":"Functions","nodes":[{"id":"create_changeset/1","deprecated":false,"title":"create_changeset(attrs)","anchor":"create_changeset/1"}],"key":"functions"}]},{"id":"GameApp.Workers.IncrementWorker","deprecated":false,"group":"","title":"GameApp.Workers.IncrementWorker","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"async/1","deprecated":false,"title":"async(integer)","anchor":"async/1"},{"id":"sync/1","deprecated":false,"title":"sync(integer)","anchor":"sync/1"}],"key":"functions"}]},{"id":"GameApp.Workers.LongJobWorker","deprecated":false,"group":"","title":"GameApp.Workers.LongJobWorker","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"perform/1","deprecated":false,"title":"perform(job)","anchor":"perform/1"},{"id":"topic/0","deprecated":false,"title":"topic()","anchor":"topic/0"}],"key":"functions"}]},{"id":"GameAppWeb","deprecated":false,"group":"","title":"GameAppWeb","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"__using__/1","deprecated":false,"title":"__using__(which)","anchor":"__using__/1"},{"id":"channel/0","deprecated":false,"title":"channel()","anchor":"channel/0"},{"id":"controller/0","deprecated":false,"title":"controller()","anchor":"controller/0"},{"id":"html/0","deprecated":false,"title":"html()","anchor":"html/0"},{"id":"live_component/0","deprecated":false,"title":"live_component()","anchor":"live_component/0"},{"id":"live_view/0","deprecated":false,"title":"live_view()","anchor":"live_view/0"},{"id":"router/0","deprecated":false,"title":"router()","anchor":"router/0"},{"id":"static_paths/0","deprecated":false,"title":"static_paths()","anchor":"static_paths/0"},{"id":"verified_routes/0","deprecated":false,"title":"verified_routes()","anchor":"verified_routes/0"}],"key":"functions"}]},{"id":"GameAppWeb.CoreComponents","deprecated":false,"group":"","title":"GameAppWeb.CoreComponents","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"back/1","deprecated":false,"title":"back(assigns)","anchor":"back/1"},{"id":"button/1","deprecated":false,"title":"button(assigns)","anchor":"button/1"},{"id":"error/1","deprecated":false,"title":"error(assigns)","anchor":"error/1"},{"id":"flash/1","deprecated":false,"title":"flash(assigns)","anchor":"flash/1"},{"id":"flash_group/1","deprecated":false,"title":"flash_group(assigns)","anchor":"flash_group/1"},{"id":"header/1","deprecated":false,"title":"header(assigns)","anchor":"header/1"},{"id":"hide/2","deprecated":false,"title":"hide(js \\\\ %JS{}, selector)","anchor":"hide/2"},{"id":"hide_modal/2","deprecated":false,"title":"hide_modal(js \\\\ %JS{}, id)","anchor":"hide_modal/2"},{"id":"icon/1","deprecated":false,"title":"icon(assigns)","anchor":"icon/1"},{"id":"input/1","deprecated":false,"title":"input(assigns)","anchor":"input/1"},{"id":"label/1","deprecated":false,"title":"label(assigns)","anchor":"label/1"},{"id":"list/1","deprecated":false,"title":"list(assigns)","anchor":"list/1"},{"id":"modal/1","deprecated":false,"title":"modal(assigns)","anchor":"modal/1"},{"id":"show/2","deprecated":false,"title":"show(js \\\\ %JS{}, selector)","anchor":"show/2"},{"id":"show_modal/2","deprecated":false,"title":"show_modal(js \\\\ %JS{}, id)","anchor":"show_modal/2"},{"id":"simple_form/1","deprecated":false,"title":"simple_form(assigns)","anchor":"simple_form/1"},{"id":"table/1","deprecated":false,"title":"table(assigns)","anchor":"table/1"},{"id":"translate_error/1","deprecated":false,"title":"translate_error(arg)","anchor":"translate_error/1"},{"id":"translate_errors/2","deprecated":false,"title":"translate_errors(errors, field)","anchor":"translate_errors/2"}],"key":"functions"}]},{"id":"GameAppWeb.Endpoint","deprecated":false,"group":"","title":"GameAppWeb.Endpoint","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"broadcast/3","deprecated":false,"title":"broadcast(topic, event, msg)","anchor":"broadcast/3"},{"id":"broadcast!/3","deprecated":false,"title":"broadcast!(topic, event, msg)","anchor":"broadcast!/3"},{"id":"broadcast_from/4","deprecated":false,"title":"broadcast_from(from, topic, event, msg)","anchor":"broadcast_from/4"},{"id":"broadcast_from!/4","deprecated":false,"title":"broadcast_from!(from, topic, event, msg)","anchor":"broadcast_from!/4"},{"id":"call/2","deprecated":false,"title":"call(conn, opts)","anchor":"call/2"},{"id":"child_spec/1","deprecated":false,"title":"child_spec(opts)","anchor":"child_spec/1"},{"id":"config/2","deprecated":false,"title":"config(key, default \\\\ nil)","anchor":"config/2"},{"id":"config_change/2","deprecated":false,"title":"config_change(changed, removed)","anchor":"config_change/2"},{"id":"host/0","deprecated":false,"title":"host()","anchor":"host/0"},{"id":"init/1","deprecated":false,"title":"init(opts)","anchor":"init/1"},{"id":"local_broadcast/3","deprecated":false,"title":"local_broadcast(topic, event, msg)","anchor":"local_broadcast/3"},{"id":"local_broadcast_from/4","deprecated":false,"title":"local_broadcast_from(from, topic, event, msg)","anchor":"local_broadcast_from/4"},{"id":"path/1","deprecated":false,"title":"path(path)","anchor":"path/1"},{"id":"script_name/0","deprecated":false,"title":"script_name()","anchor":"script_name/0"},{"id":"server_info/1","deprecated":false,"title":"server_info(scheme)","anchor":"server_info/1"},{"id":"start_link/1","deprecated":false,"title":"start_link(opts \\\\ [])","anchor":"start_link/1"},{"id":"static_integrity/1","deprecated":false,"title":"static_integrity(path)","anchor":"static_integrity/1"},{"id":"static_lookup/1","deprecated":false,"title":"static_lookup(path)","anchor":"static_lookup/1"},{"id":"static_path/1","deprecated":false,"title":"static_path(path)","anchor":"static_path/1"},{"id":"static_url/0","deprecated":false,"title":"static_url()","anchor":"static_url/0"},{"id":"struct_url/0","deprecated":false,"title":"struct_url()","anchor":"struct_url/0"},{"id":"subscribe/2","deprecated":false,"title":"subscribe(topic, opts \\\\ [])","anchor":"subscribe/2"},{"id":"unsubscribe/1","deprecated":false,"title":"unsubscribe(topic)","anchor":"unsubscribe/1"},{"id":"url/0","deprecated":false,"title":"url()","anchor":"url/0"}],"key":"functions"}]},{"id":"GameAppWeb.ErrorHTML","deprecated":false,"group":"","title":"GameAppWeb.ErrorHTML","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"render/2","deprecated":false,"title":"render(template, assigns)","anchor":"render/2"}],"key":"functions"}]},{"id":"GameAppWeb.ErrorJSON","deprecated":false,"group":"","title":"GameAppWeb.ErrorJSON","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"render/2","deprecated":false,"title":"render(template, assigns)","anchor":"render/2"}],"key":"functions"}]},{"id":"GameAppWeb.GetTextLive.Index","deprecated":false,"group":"","title":"GameAppWeb.GetTextLive.Index","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"render/1","deprecated":false,"title":"render(assigns)","anchor":"render/1"}],"key":"functions"}]},{"id":"GameAppWeb.Gettext","deprecated":false,"group":"","title":"GameAppWeb.Gettext","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"dgettext/3","deprecated":false,"title":"dgettext(domain, msgid, bindings \\\\ Macro.escape(%{}))","anchor":"dgettext/3"},{"id":"dgettext_noop/2","deprecated":false,"title":"dgettext_noop(domain, msgid)","anchor":"dgettext_noop/2"},{"id":"dngettext/5","deprecated":false,"title":"dngettext(domain, msgid, msgid_plural, n, bindings \\\\ Macro.escape(%{}))","anchor":"dngettext/5"},{"id":"dngettext_noop/3","deprecated":false,"title":"dngettext_noop(domain, msgid, msgid_plural)","anchor":"dngettext_noop/3"},{"id":"dpgettext/4","deprecated":false,"title":"dpgettext(domain, msgctxt, msgid, bindings \\\\ Macro.escape(%{}))","anchor":"dpgettext/4"},{"id":"dpgettext_noop/3","deprecated":false,"title":"dpgettext_noop(domain, msgctxt, msgid)","anchor":"dpgettext_noop/3"},{"id":"dpngettext/6","deprecated":false,"title":"dpngettext(domain, msgctxt, msgid, msgid_plural, n, bindings \\\\ Macro.escape(%{}))","anchor":"dpngettext/6"},{"id":"dpngettext_noop/4","deprecated":false,"title":"dpngettext_noop(domain, msgctxt, msgid, msgid_plural)","anchor":"dpngettext_noop/4"},{"id":"gettext/2","deprecated":false,"title":"gettext(msgid, bindings \\\\ Macro.escape(%{}))","anchor":"gettext/2"},{"id":"gettext_comment/1","deprecated":false,"title":"gettext_comment(comment)","anchor":"gettext_comment/1"},{"id":"gettext_noop/1","deprecated":false,"title":"gettext_noop(msgid)","anchor":"gettext_noop/1"},{"id":"handle_missing_bindings/2","deprecated":false,"title":"handle_missing_bindings(exception, incomplete)","anchor":"handle_missing_bindings/2"},{"id":"handle_missing_plural_translation/7","deprecated":false,"title":"handle_missing_plural_translation(locale, domain, msgctxt, msgid, msgid_plural, n, bindings)","anchor":"handle_missing_plural_translation/7"},{"id":"handle_missing_translation/5","deprecated":false,"title":"handle_missing_translation(locale, domain, msgctxt, msgid, bindings)","anchor":"handle_missing_translation/5"},{"id":"lgettext/5","deprecated":false,"title":"lgettext(locale, domain, msgctxt \\\\ nil, msgid, bindings)","anchor":"lgettext/5"},{"id":"lngettext/7","deprecated":false,"title":"lngettext(locale, domain, msgctxt \\\\ nil, msgid, msgid_plural, n, bindings)","anchor":"lngettext/7"},{"id":"ngettext/4","deprecated":false,"title":"ngettext(msgid, msgid_plural, n, bindings \\\\ Macro.escape(%{}))","anchor":"ngettext/4"},{"id":"ngettext_noop/2","deprecated":false,"title":"ngettext_noop(msgid, msgid_plural)","anchor":"ngettext_noop/2"},{"id":"pgettext/3","deprecated":false,"title":"pgettext(msgctxt, msgid, bindings \\\\ Macro.escape(%{}))","anchor":"pgettext/3"},{"id":"pgettext_noop/2","deprecated":false,"title":"pgettext_noop(msgid, context)","anchor":"pgettext_noop/2"},{"id":"pngettext/5","deprecated":false,"title":"pngettext(msgctxt, msgid, msgid_plural, n, bindings \\\\ Macro.escape(%{}))","anchor":"pngettext/5"},{"id":"pngettext_noop/3","deprecated":false,"title":"pngettext_noop(msgctxt, msgid, msgid_plural)","anchor":"pngettext_noop/3"}],"key":"functions"}]},{"id":"GameAppWeb.IncrementLive.Index","deprecated":false,"group":"","title":"GameAppWeb.IncrementLive.Index","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"render/1","deprecated":false,"title":"render(assigns)","anchor":"render/1"}],"key":"functions"}]},{"id":"GameAppWeb.Layouts","deprecated":false,"group":"","title":"GameAppWeb.Layouts","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"app/1","deprecated":false,"title":"app(assigns)","anchor":"app/1"},{"id":"root/1","deprecated":false,"title":"root(assigns)","anchor":"root/1"}],"key":"functions"}]},{"id":"GameAppWeb.LongJobLive.Index","deprecated":false,"group":"","title":"GameAppWeb.LongJobLive.Index","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"render/1","deprecated":false,"title":"render(assigns)","anchor":"render/1"}],"key":"functions"}]},{"id":"GameAppWeb.PageController","deprecated":false,"group":"","title":"GameAppWeb.PageController","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"home/2","deprecated":false,"title":"home(conn, params)","anchor":"home/2"}],"key":"functions"}]},{"id":"GameAppWeb.PageHTML","deprecated":false,"group":"","title":"GameAppWeb.PageHTML","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"home/1","deprecated":false,"title":"home(assigns)","anchor":"home/1"}],"key":"functions"}]},{"id":"GameAppWeb.PlayerLive.FormComponent","deprecated":false,"group":"","title":"GameAppWeb.PlayerLive.FormComponent","sections":[]},{"id":"GameAppWeb.PlayerLive.Index","deprecated":false,"group":"","title":"GameAppWeb.PlayerLive.Index","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"handle_event/3","deprecated":false,"title":"handle_event(binary, map, socket)","anchor":"handle_event/3"},{"id":"handle_info/2","deprecated":false,"title":"handle_info(arg, socket)","anchor":"handle_info/2"},{"id":"handle_params/3","deprecated":false,"title":"handle_params(params, url, socket)","anchor":"handle_params/3"},{"id":"mount/3","deprecated":false,"title":"mount(params, session, socket)","anchor":"mount/3"},{"id":"render/1","deprecated":false,"title":"render(assigns)","anchor":"render/1"}],"key":"functions"}]},{"id":"GameAppWeb.PlayerLive.Show","deprecated":false,"group":"","title":"GameAppWeb.PlayerLive.Show","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"handle_params/3","deprecated":false,"title":"handle_params(map, _, socket)","anchor":"handle_params/3"},{"id":"render/1","deprecated":false,"title":"render(assigns)","anchor":"render/1"}],"key":"functions"}]},{"id":"GameAppWeb.Router","deprecated":false,"group":"","title":"GameAppWeb.Router","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"api/2","deprecated":false,"title":"api(conn, _)","anchor":"api/2"},{"id":"browser/2","deprecated":false,"title":"browser(conn, _)","anchor":"browser/2"},{"id":"call/2","deprecated":false,"title":"call(conn, opts)","anchor":"call/2"},{"id":"init/1","deprecated":false,"title":"init(opts)","anchor":"init/1"}],"key":"functions"}]},{"id":"GameAppWeb.Telemetry","deprecated":false,"group":"","title":"GameAppWeb.Telemetry","sections":[],"nodeGroups":[{"name":"Functions","nodes":[{"id":"child_spec/1","deprecated":false,"title":"child_spec(init_arg)","anchor":"child_spec/1"},{"id":"metrics/0","deprecated":false,"title":"metrics()","anchor":"metrics/0"},{"id":"start_link/1","deprecated":false,"title":"start_link(arg)","anchor":"start_link/1"}],"key":"functions"}]}],"extras":[{"id":"api-reference","group":"","title":"API Reference","headers":[{"id":"Modules","anchor":"modules"}]}],"tasks":[]}