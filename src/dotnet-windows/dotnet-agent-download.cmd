@echo off

set AGENT_VERSION=%1

if "%AGENT_VERSION%"=="latest" (
    curl.exe -L -o newrelic-agent.zip https://download.newrelic.com/dot_net_agent/latest_release/NewRelicDotNetAgent_x64.zip
) else (
    curl.exe -L -o newrelic-agent.zip https://download.newrelic.com/dot_net_agent/latest_release/NewRelicDotNetAgent_%AGENT_VERSION%_x64.zip
)

tar.exe -xzf newrelic-agent.zip || exit /b 1
del newrelic-agent.zip
