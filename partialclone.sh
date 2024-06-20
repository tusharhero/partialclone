#!/bin/sh
# partialclone.sh - Clone a single directory or file from a Git repository.
# Copyright (C) 2024 tusharhero

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

giturl=$1
content=$2

cachedir="${XDG_CACHE_HOME:-$HOME/.cache}/partialclone"
cachedir="${PARTIALCLONE_CACHE:-$cachedir}"

repository=$(echo "$giturl" | awk -F '/' '{ print $(NF) }')

if [ -z "$repository" ]; then
    # If the URL had a trailing slash.
    repository=$(echo "$giturl" | awk -F '/' '{ print $(NF-1) }')
    namespace=$(echo "$giturl" | awk -F '/' '{ print $(NF-2) }')
else
    namespace=$(echo "$giturl" | awk -F '/' '{ print $(NF-1) }')
fi

cacherepo="$cachedir/$namespace/$repository"
branch='main'

if [ -d "$cacherepo/.git" ]; then
    cd "$cacherepo" && git checkout "$branch" && git pull origin "$branch"
else
    git clone --depth 1 "$giturl" "$cacherepo"
fi

cp -irv "$cacherepo/$content" .
