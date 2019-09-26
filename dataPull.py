#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 24 14:55:19 2019

@author: dusty
"""
import pandas as pd

from sqlalchemy import create_engine
engineStr = 'mysql+mysqlconnector://viewer:' # Connector
engineStr += '@dadata.cba.edu:3306' # Server Address
engineStr += '/NFL' # Database Name
engine = create_engine(engineStr) # Start the Engine

select = """
    SELECT
        team.tname AS team,
        game.seas AS season,
        game.wk AS week,
        game.sprv AS spreadAway,
        game.ou AS overUnder,
        CASE
            WHEN game.h=team.tname
                THEN game.ptsh
            ELSE game.ptsv
            END
            AS pointsFor,
        CASE
            WHEN game.h=team.tname
                THEN game.ptsv
            ELSE game.ptsh
            END
            AS pointsAgainst,
        CASE
            WHEN game.h=team.tname AND game.ptsh>game.ptsv
                THEN 1
            WHEN game.v=team.tname AND game.ptsh<game.ptsv
                THEN 1
            WHEN game.ptsv=game.ptsh
                THEN 0.5
            ELSE 0
            END
            AS win,
        CASE
            WHEN game.h=team.tname
                THEN game.v
            ELSE game.h
            END
            AS opponent,
        CASE
            WHEN team.tname=game.h
                THEN 1
            ELSE 0
            END
            AS homeTeam,
        team.ry AS rushYards,
        team.ra AS rushAttempts,
        team.py AS passYards,
        team.pc AS passCompletions,
        team.sk AS sacksAgainst,
        team.top AS timeOfPoss,
        team.pen AS penYardsAgainst,
        team.tdr AS rushTD,
        team.tdp AS passTD
    FROM
        game, team
    WHERE
        game.gid = team.gid
        AND ((game.v = team.tname) OR (game.h = team.tname))
"""



data = pd.read_sql(select, engine)