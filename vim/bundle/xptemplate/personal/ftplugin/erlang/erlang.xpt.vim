XPTemplate priority=personal

XPTinclude
      \ _common/common

XPTvar $DATE_FMT     '%d/%m/%Y'

let s:f = g:XPTfuncs()

fun! s:f.getFunName()
    let cursor = [line('.'), col('.')]
    let line = getline(cursor[0] + 1)
    let head = matchstr(line, '^\w\+(\@=')

    return head
endfun

XPT @a " @author
@author Stanislav Seletskiy <s.seletskiy@office.ngs.ru>`cursor^

XPT @d " @doc
@doc `cursor^

XPT m " -module\(...)
XSET name|def=S(file(), '\.erl$', '')
`:@@f:^
-module(`name^).
-created('Date: `:Date:^').
-created_by('Stanislav Seletskiy <s.seletskiy@office.ngs.ru>').

XPT d " -define\(...)
-define(`name^, `val^).`cursor^

XPT b " -behaviour\(...)
-behaviour(`behaviour^).`cursor^

XPT e " -export\(...)
-export([`fun^]).`cursor^

XPT r " -record\(...)
-record(`name^, {`cursor^}).

XPT fun " fun\(...) -> ... end
fun(`args^) -> `body^ end`cursor^

XPT f " fun\(...) ->
`head^(`args^) ->
    `cursor^.

XPT app " application template
XSET module|def=S(file(), '\.erl$', '')
-behaviour(application).

-export([start/2, stop/1]).

%% ---------------------------------------------------------------------
%% Public methods (открытые методы).
%% ---------------------------------------------------------------------

%% @doc Starts an application.
start(_Type, _Args) ->
	`module^_sup:start_link().

%% @doc Stops an application.
stop(_State) ->
	ok.

XPT gs " gen_server template
-behaviour(gen_server).

-export([
    start_link/0,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

`:%%pub:^
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------------
%% gen_server specific.
%% ---------------------------------------------------------------------
init(_Args) ->
    {ok, nil}.

handle_call(_Message, _From, State) ->
    {noreply, State}.

handle_cast(_Message, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

XPT nrp " noreply
{noreply, `State^}

XPT rp " reply
{reply, `Reply^, `NewState^}

XPT gsc " gen_server:call
gen_server:call(`?MODULE^, `Msg^).

XPT gsca " gen_server:cast
gen_server:cast(`?MODULE^, `Msg^).

XPT hc " handle_call
handle_call(`_Message^, `_From^, `State^) ->
    `cursor^;

XPT hca " handle_cast
handle_cast(`_Message^, `State^) ->
    {noreply, `State^};

XPT hi " handle_info
handle_info(`_Info^, `State^) ->
    `cursor^,
    {noreply, `State^};

XPT bi " behaviour_info
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [`cursor^];

behaviour_info(_) ->
    undefined.

XPT %%pri
%% ---------------------------------------------------------------------
%% Private methods.
%% ---------------------------------------------------------------------

XPT %%pub
%% ---------------------------------------------------------------------
%% Public methods.
%% ---------------------------------------------------------------------

XPT %%
%% ---------------------------------------------------------------------
%% `comment^
%% ---------------------------------------------------------------------

XPT @@f
%% `:@a:^
%% `:@d:^


XPT s
XSET head|def=getFunName()
-spec `head^(`args^) -> `result^.

XPT tc
`:m:^

-include_lib("eunit/include/eunit.hrl").
-include_lib("include/eunit.hrl").

setup() ->
    ok.

teardown(_Arg) ->
    ok.

main_test_() ->
    {foreach,
        fun setup/0,
        fun teardown/1,
        ?EUNIT_DEFFERED_APPLY([
            `:tmd:^
        ])}.

XPT tmd
{"`test_name^", fun test_`test_method^/1}

XPT tmr
test_`method^(`_Arg^) ->
    `cursor^.

XPT am
?assertMatch(`expected^, `actual^)

XPT chispec
XSET Function|def=start_link
XSET Args|def=[]
XSET Restart|def=permanent
XSET Shutdown|def=5000
XSET Type|def=worker
{`Module^,
    {`Module^, `Function^, `ModArgs^},
    `Restart^,
    `Shutdown^,
    `Type^,
    [`Module^`, `AdditionalModules^]}

XPT sup
XSET RestartStrategy|def=one_for_one
-behaviour(supervisor).

-export([start_link/1, init/1]).

start_link(`Args^) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, [`Args^]).

init(_Args) ->
    {ok, {{`RestartStrategy^, `MaxRestarts^, `Interval^}, [
        `:chispec:^`,
        `Child Specification...{{^,
        `:chispec:^`,
        `Child Specification...{{^,
        `:chispec:^`}}^`}}^
    ]}}.

XPT reapp
{application, `AppName^, [
    {description, "`AppDescription^"},
    {vsn, git},
    {registered, []},
    {applications, [
        kernel,
        stdlib,
        sasl]},
    {mod, {`AppName^, []}},
    {env, []}.
