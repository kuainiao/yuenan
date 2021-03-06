%% Author: yskj
%% Created: 2013-11-6
%% Description: TODO: Add description to trans_horse
-module(trans_resource).

%%
%% Include files
%%
-include("const.common.hrl").
-include("const.define.hrl").

-include("record.player.hrl").
-include("record.data.hrl").
-include("record.base.data.hrl").

%%
%% Exported Functions
%%
-export([trans_1112/0, trans_1227/0]).

%%
%% API Functions
%%

trans_1112() ->
    misc_sys:init(),
    mysql_api:start(),
    TotalCount = 
            case mysql_api:select(<<"select count(`user_id`) from `game_user`;">>) of
                {?ok, [[TotalCountT]]} when is_number(TotalCountT) ->
                    TotalCountT;
                _ ->
                    0
            end,
    if(TotalCount > 0) ->
        OkCount = 
            case mysql_api:select(<<"select `user_id`, `resource` from `game_player`;">>) of
                {?ok, [?undefined]} -> 
                    ?MSG_SYS("undefined<-------------------", []),
                    ok;
                {?ok, DataList} ->
                    Fun = fun([UserId, ResE], OldCount) ->
                                try
                                    ResD = mysql_api:decode(ResE),
                                    ResD2 = erlang:tuple_to_list(ResD),
                                    ResD3 = erlang:list_to_tuple(ResD2++[0]),
                                    ResE2 = mysql_api:encode(ResD3), 
                                    mysql_api:update(<<"update `game_player` set `resource` = ", ResE2/binary,
                                                                     " where `user_id`=", (misc:to_binary(UserId))/binary, ";">>),
                                    OldCount2 = OldCount+1,
                                    ?MSG_SYS_ROLL("[~p/~p]", [OldCount2, TotalCount]),
                                    OldCount2
                                catch 
                                    X:Y -> 
                                        ?MSG_SYS("x=~p, y=~p, e=~p", [X,Y, erlang:get_stacktrace()]),
                                        OldCount
                                end
                    end,
                    NewCount = lists:foldl(Fun, 0, DataList),
                    NewCount;
                X ->
                    ?MSG_SYS("~p<-------------------", [X]),
                   0
            end,
        if(TotalCount - OkCount == 0) ->
            ?MSG_SYS("ok");
        ?true ->
            ?MSG_SYS("table `game_player` count not eq ~p/~p", [OkCount, TotalCount])
        end;
    ?true ->
        ?MSG_SYS("table `game_player` count=0")
    end,
    erlang:halt().


trans_1227() ->
    misc_sys:init(),
    mysql_api:start(),
    TotalCount = 
            case mysql_api:select(<<"select count(`user_id`) from `game_player`;">>) of
                {?ok, [[TotalCountT]]} when is_number(TotalCountT) ->
                    TotalCountT;
                _ ->
                    0
            end,
    if(TotalCount > 0) ->
        OkCount = 
            case mysql_api:select(<<"select `user_id`, `resource` from `game_player`;">>) of
                {?ok, [?undefined]} -> 
                    ?MSG_SYS("undefined<-------------------", []),
                    ok;
                {?ok, DataList} ->
                    Fun = fun([UserId, ResourceE], OldCount) ->
                                try
                                    ResourceD = mysql_api:decode(ResourceE),
                                    ResourceD2 = erlang:tuple_to_list(ResourceD),
                                    ResourceD3 = erlang:list_to_tuple(ResourceD2++[0]),
                                    ResourceE2= mysql_api:encode(ResourceD3), 
                                    mysql_api:update(<<"update `game_player` set `resource` = ", ResourceE2/binary,
                                                                     " where `user_id`=", (misc:to_binary(UserId))/binary, ";">>),
                                    OldCount2 = OldCount+1,
                                    ?MSG_SYS_ROLL("[~p/~p]", [OldCount2, TotalCount]),
                                    OldCount2
                                catch 
                                    X:Y -> 
                                        ?MSG_SYS("x=~p, y=~p, e=~p", [X,Y, erlang:get_stacktrace()]),
                                        OldCount
                                end
                    end,
                    NewCount = lists:foldl(Fun, 0, DataList),
                    NewCount;
                X ->
                    ?MSG_SYS("~p<-------------------", [X]),
                   0
            end,
        if(TotalCount - OkCount == 0) ->
            ?MSG_SYS("ok");
        ?true ->
            ?MSG_SYS("table `game_player` count not eq ~p/~p", [OkCount, TotalCount])
        end;
    ?true ->
        ?MSG_SYS("table `game_player` count=0")
    end,
    erlang:halt().

%%
%% Local Functions
%%

