/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Utils {

    public static func isAtLeastVersion(major: Int32, minor: Int32, patch: Int32, minMajor: Int32, minMinor: Int32, minPatch: Int32): Bool {
        if (major < minMajor) {
          return false
        } else if (major > minMajor) {
          return true
        }

        if (minor < minMinor) {
          return false
        } else if (minor > minMinor) {
          return true
        }

        return patch >= minPatch
    }

}
