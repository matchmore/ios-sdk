#!/bin/sh
# generates nscoder swift code using sourcery and generated swagger code
sourcery --templates Templates/ --sources Alps/Classes/Swaggers/Models --output Alps/Classes/Swaggers/Models
