#!/bin/bash
#
# Bash completion support for xcodebuild

_xcodebuild ()
{
    compopt +o default
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    local two_prev="${COMP_WORDS[COMP_CWORD-2]}"

    # Subcommand list
    local options="-project -target -alltargets -workspace -scheme -destination -destination -configuration -arch -sdk -showsdks -showBuildSettings -showdestinations -showBuildTimingSummary -list -enableAddressSanitizer -enableThreadSanitizer -enableUndefinedBehaviorSanitizer -enableCodeCoverage -testLanguage -testRegion -derivedDataPath -resultBundlePath -allowProvisioningUpdates -allowProvisioningDeviceRegistration -exportArchive -exportNotarizedApp -archivePath -exportPath -exportOptionsPlist -exportLocalizations -importLocalizations -localizationPath -exportLanguage -xcconfig -xctestrun -skip -disable -maximum -maximum -parallel -parallel -maximum -dry -n -skipUnavailableActions buildsetting -userdefault -toolchain -quiet -verbose -version -license -checkFirstLaunchStatus -runFirstLaunch -usage"
    local actions="build build-for-testing analyze archive test test-without-building install-src install clean"
    [[ ${COMP_CWORD} -eq 1 ]] && {
        COMPREPLY=( $(compgen -W "${options} ${actions}" -- ${cur}) )
        return
    }
    if [[ ${COMP_CWORD} -eq 2 ]]; then
        case "$prev" in
            print|enable|disable|blame|runstats|bootstrap|bootout|debug)
                compopt -o nospace
                if [[ ${cur} == */*/* ]]; then
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_service_targets)" -- ${cur}) )
                elif [[ ${cur} == */* ]]; then
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_subdomains)" -- ${cur}) )
                else
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_domains)" -- ${cur}) )
                fi
                return
                ;;
            submit)
                COMPREPLY=( $(compgen -W "-l" -- ${cur}) )
                return
                ;;
            help)
                COMPREPLY=( $(compgen -W "$subcommands" -- ${cur}) )
                return
                ;;
            kickstart)
                COMPREPLY=( $(compgen -W "-k -p -s" -- ${cur}) )
                return
                ;;
            reboot)
                COMPREPLY=( $(compgen -W "-s system halt userspace reroot logout apps" -- ${cur}) )
                return
                ;;
            attach)
                COMPREPLY=( $(compgen -W "-k -s -x" -- ${cur}) )
                return
                ;;
            bootshell)
                COMPREPLY=( $(compgen -W "continue" -- ${cur}) )
                return
                ;;
            procinfo|resolveport)
                COMPREPLY=( $(compgen -W '$(__xcodebuild_list_pids)' -- ${cur}) )
                return
                ;;
            error)
                COMPREPLY=( $(compgen -W "posix mach bootstrap" -- ${cur}) )
                return
                ;;
            remove|list|uncache)
                COMPREPLY=( $(compgen -W "$(__xcodebuild_list_labels)" -- ${cur}) )
                return
                ;;
            start)
                COMPREPLY=( $(compgen -W "$(__xcodebuild_list_stopped)" -- ${cur}) )
                return
                ;;
            stop)
                COMPREPLY=( $(compgen -W "$(__xcodebuild_list_started)" -- ${cur}) )
                return
                ;;
            kill)
                COMPREPLY=( $(compgen -W "$(__xcodebuild_list_sigs)" -- ${cur}) )
                return
                ;;
            bsexec)
                COMPREPLY=( $(compgen -W '$(__xcodebuild_list_pids)' -- ${cur}) )
                return
                ;;
            asuser)
                COMPREPLY=( $(compgen -W '$(__xcodebuild_list_uids)' -- ${cur}) )
                return
                ;;
            config)
                COMPREPLY=( $(compgen -W 'system user' -- ${cur}) )
                return
                ;;
            load|unload)
                compopt -o filenames
                compopt -o nospace
                COMPREPLY=( $(compgen -f -- ${cur}) )
                return
                ;;
        esac
    fi
    if [[ ${COMP_CWORD} -eq 3 ]]; then
        case "$two_prev" in
            config)
                COMPREPLY=( $(compgen -W "umask path" -- ${cur}) )
                return
                ;;
            reboot)
                COMPREPLY=( $(compgen -W "system halt userspace reroot logout apps" -- ${cur}) )
                return
                ;;
            kill|attach|kickstart)
                compopt -o nospace
                if [[ ${cur} == */*/* ]]; then
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_service_targets)" -- ${cur}) )
                elif [[ ${cur} == */* ]]; then
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_subdomains)" -- ${cur}) )
                else
                    COMPREPLY=( $(compgen -W "$(__xcodebuild_list_domains)" -- ${cur}) )
                fi
                return
                ;;
            bootstrap|bootout)
                compopt -o filenames
                compopt -o nospace
                COMPREPLY=( $(compgen -f -- ${cur}) )
                return
                ;;
            # resolveport)
            #     COMPREPLY=( $(compgen -W "$(__xcodebuild_list_ports)" -- ${cur}) )
            #     return
            #     ;;
        esac
    fi
}

complete -F _xcodebuild xcodebuild
